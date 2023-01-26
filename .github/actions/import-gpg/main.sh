#!/bin/zsh

set -eo pipefail

# Get inputs
declare -A env
while read -d $'\0' -r e; do
  name=${e%%=*}
  value=${e#*=}
  name=$(echo $name | sed -r 's/^INPUT_(.+)$/\1/g')
  env[$name]=$value
done < <(env -0 | grep -e '^INPUT_' -z)

# Import the GPG secret key
echo ::group ::Import the GPG secret key
echo "${env[SECRET-KEY]}" \
  | gpg --batch --import --yes $keypath
echo ::endgroup ::

# Reload GPG Agent
echo ::group ::Reload GPG Agent
cat << _EOT_ > ${GNUPGHOME:-$HOME/.gnupg}/gpg-agent.conf
allow-preset-passphrase
default-cache-ttl 21600
max-cache-ttl 31536000
_EOT_
cat << _EOT_ | gpg-connect-agent
reloadagent
/bye
_EOT_
echo ::endgroup ::

# Parse the imported key
echo ::group ::Parse the imported key
declare -A key
while read -r line; do
  case ${line%%:*} in
    fpr)
        key[fingerprint]=${${line%:*}##*:}
        echo fingerprint ${key[fingerprint]} >&2
        [[ ${key[fingerprint]} = ${env[FINGERPRINT]} ]]  \
          && key[matched]=${key[id]}
      ;;
    grp)
        key[keygrip]=${${line%:*}##*:}
        echo keygrip ${key[keygrip]} >&2
      ;;
    sec)
        [[ -z ${key[matched]} ]] || break
        local c=${line#*:*:*:*:}
        [[ -z ${key[id]} ]] || echo >&2
        key[id]=${c%%:*}
        key[timestamp]=${${c#*:}%%:*}
        echo secret-key ${key[id]} $(date -d @${key[timestamp]} "+%Y/%m/%d %H:%M:%S") >&2
      ;;
    ssb)
        [[ -z ${key[matched]} ]] || break
        local c=${line#*:*:*:*:}
        local id=${c%%:*}
        key[primaryKeyId]=${key[id]}
        key[id]=$id
        key[timestamp]=${${c#*:}%%:*}
        echo >&2
        echo subkey ${key[id]} $(date -d @${key[timestamp]} "+%Y/%m/%d %H:%M:%S") >&2
      ;;
    uid)
        user=${line#*:*:*:*:*:*:*:*:*:}
        key[name]=${user%\ *}
        key[mail]=$(echo ${user##*\ } | grep -P '(?<=\<)[^\>]+(?=\>)' -o)
        echo user ${key[name]} >&2
        echo mail ${key[mail]} >&2
      ;;
  esac
done < <(gpg --batch --list-secret-keys --with-colons --with-keygrip)
echo ::endgroup ::

# Preset passphrase for the relevant keygrip
echo ::group ::Preset passphrase
passphrase=$(printf '%s' ${env[PASSPHRASE]} | hexdump -e '1/1 "%.2x"' -v)
cat << _EOT_ | gpg-connect-agent
preset_passphrase ${key[keygrip]} -1 $passphrase
/bye
_EOT_
echo ::endgroup ::

# Configure git
git config user.email "${key[mail]}"
git config user.name "${key[name]}"
