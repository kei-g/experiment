#!/bin/bash

# Get inputs
echo ::group ::Get inputs
declare -A env
while read -d $'\0' -r e; do
  name=${e%%=*}
  value=${e#*=}
  env[$name]=$value
done < <(env -0)
[[ -z ${env[fingerprint]} ]] && { echo No fingerprint is passed >&2; exit 1; }
[[ -z ${env[passphrase]} ]] && { echo No passphrase is passed >&2; exit 1; }
[[ -z ${env[secret-key]} ]] && { echo No secret key is passed >&2; exit 1; }
echo OK
echo ::endgroup ::

# Import the GPG public key
[[ -n "${env[public-key]}" ]] && {
  echo ::group ::Import the GPG public key
  tmpdir=$(mktemp -d)
  key=$tmpdir/${env[fingerprint]}.pub
  echo "${env[public-key]}" > $key
  gpg --batch --import --yes $key
  rm -fr $tmpdir
  echo ::endgroup ::
}

# Import the GPG secret key
echo ::group ::Import the GPG secret key
tmpdir=$(mktemp -d)
key=$tmpdir/${env[fingerprint]}.key
echo "${env[secret-key]}" > $key
gpg --batch --import --yes $key
rm -fr $tmpdir
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
  cols=()
  while read -d':' -r col; do
    [[ -z "$col" ]] || cols+=("$col")
  done < <(echo $line)
  case ${cols[0]} in
    fpr)
        [[ ${cols[1]} =~ ${env[fingerprint]} ]] \
          && key[fingerprint]=${cols[1]}
        echo [fingerprint] ${cols[1]}
      ;;
    grp)
        [[ "${!key[@]}" =~ fingerprint ]] \
          && key[keygrip]=${cols[1]}
        echo [keygrip] ${cols[1]}
      ;;
    sec)
        [[ "${!key[@]}" =~ fingerprint ]] \
          || {
            key[id]=${cols[4]}
            key[timestamp]=$(date -d @${cols[5]} "+%Y/%m/%d %H:%M:%S %Z")
            unset key[keygrip]
            unset key[primary]
            unset key[primary-timestamp]
          }
        echo [key] ${cols[4]}
      ;;
    ssb)
        [[ "${!key[@]}" =~ fingerprint ]] \
          || {
            key[primary]=${key[id]}
            key[id]=${cols[4]}
            key[primary-timestamp]=${key[timestamp]}
            key[timestamp]=$(date -d @${cols[5]} "+%Y/%m/%d %H:%M:%S %Z")
          }
        echo [subkey] ${cols[4]}
      ;;
    uid)
        user=${cols[4]}
        key[name]=${user%\ *}
        key[mail]=$(echo "${user##*\ }" | grep -P '(?<=\<)[^\>]+(?=\>)' -o)
        echo [user]
        echo "  [name] ${key[name]}"
        echo "  [email] ${key[mail]}"
      ;;
  esac
done < <(gpg --batch --list-secret-keys --with-colons --with-keygrip)
echo ::endgroup ::

# Preset passphrase for the relevant keygrip
echo ::group ::Preset passphrase
passphrase=$(printf '%s' ${env[passphrase]} | hexdump -e '1/1 "%.2x"' -v)
cat << _EOT_ | gpg-connect-agent
preset_passphrase ${key[keygrip]} -1 $passphrase
/bye
_EOT_
echo ::endgroup ::

# Configure git
git config --global user.email "${key[mail]}"
git config --global user.name "${key[name]}"

# Output
echo ::group ::Outputs
cat << _EOT_ | tee -a $GITHUB_OUTPUT
created-at=${key[timestamp]}
email=${key[mail]}
fingerprint=${key[fingerprint]}
id=${key[id]}
keygrip=${key[keygrip]}
user=${key[name]}
_EOT_
echo ::endgroup ::
