# ChangeLogs

## Version 1.0.3

- :green_heart: CI chore
  - Dependabot has become to be applied also to GitHub Actions
  - Looser version has become to be specified for `kei-g/experiment`
- :arrow_up: GitHub Action is bumped
  - `github/codeql-action` is bumped from v1 to v2
- :arrow_up: Packages are bumped
  - `typescript` is bumped from 4.6.3 to 4.6.4
- :wrench:
  - 'dist/index.ts' has become to be transpiled with --target=ES2015

## Version 1.0.2

- :wrench: 'author' is fixed
- :hammer: Build scripts are improved
  - A command to transpile 'src/dist/index.ts' is added
  - pre- and post- are separated from the 'build' command
- :green_heart: CI is improved
  - 'paths-ignore' is removed from triggers to be analyzed by CodeQL
  - `open-pull-requests-limit` is increased to 16
  - A Farewell to Travis
  - Jobs are made to be compact in one
  - Target branch for Dependabot is changed from 'main' to 'devel'
  - The trigger to create release is fixed
  - Unnecessary jobs are purged
- :arrow_up: GitHub Actions are bumped
  - `actions/checkout` is bumped from v2 to v3
  - `actions/setup-node` is bumped from v2 to v3
  - `actions/upload-artifact` is bumped from v2 to v3
- :arrow_up: Packages are bumped
  - `@actions/core` is bumped from 1.6.0 to 1.7.0
  - `@types/chai` is bumped from 4.3.0 to 4.3.1
  - `@types/mocha` is bumped from 9.1.0 to 9.1.1
  - `@types/node` is bumped from 16.11.12 to 17.0.30
  - `@typescript-eslint/eslint-plugin` is bumped from 5.6.0 to 5.21.0
  - `@typescript-eslint/parser` is bumped from 5.6.0 to 5.21.0
  - `esbuild` is bumped from 0.14.2 to 0.14.38
  - `eslint` is bumped from 8.4.1 to 8.14.0
  - `typescript` is bumped from 4.5.3 to 4.6.3

## Version 1.0.1

- :green_heart: 'package.json' is used for key of cache
- :see_no_evil: 'package-lock.json' is removed from '.gitignore' to use cache on GitHub CI
- :hammer: .d.ts files are removed on 'clean' with wildcard
- :memo: Badge URLs are fixed
- :green_heart: Change format for list in YAML
- :robot: Dependabot is installed
- :green_heart: Example job is added
- :alembic: Experiment for creating release
- :alembic: Experiment of badges per GitHub Action jobs
- :memo: GitHub Actions' canonical badge is used instead of Shields.io
- :sparkles: GitHub custom action is implemented
- :alembic: Node.js are bumped for GitHub CI
- :arrow_up: Packages are bumped
  - `@types/chai` is bumped from 4.2.22 to 4.3.0
  - `@types/node` is bumped from 16.11.9 to 16.11.12
  - `@typescript-eslint/eslint-plugin` is bumped from 5.4.0 to 5.6.0
  - `@typescript-eslint/parser` is bumped from 5.4.0 to 5.6.0
  - `eslint` is bumped from 8.3.0 to 8.4.1
  - `esbuild` is bumped from 0.13.15 to 0.14.2
  - `typescript` is bumped from 4.4.4 to 4.5.3

## Version 1.0.0

- :tada: Initial release
