This file provides guidance to AI coding assistants like Enkaidu and Claude Code when working with code in this repository.

## Overview

`crops` is a Crystal rewrite of the `ops` tool, which allows you to add shell commands to `ops.yml` and run them via shortcuts when you're in that directory. `ops.yml` becomes a context-aware place to add common commands.

## Architecture

The codebase is structured as follows:

### Source Code
- **`src/ops.cr`**: Main entry point for the application
- **`src/action.cr`**: Handles action execution
- **`src/dependencies/`**: Contains dependency management logic
  - Each file (e.g., `brew.cr`, `gem.cr`) handles a specific dependency type
- **`src/builtins/`**: Implements built-in commands
  - Includes commands like `up`, `down`, `env`, `init`, etc.
- **`src/options.cr`**: Configuration and options parsing

### Key Components
- **Dependency Management**: Supports brew, gem, apt, apk, docker, custom commands, directories, and SSH keys
- **Config Loading**: Loads configuration from YAML/JSON files in `config/$environment/` directories
- **Environment Variables**: Manages environment variables from config, secrets, and options

## Development Commands

### Building and Running
- Build the project:
  ```shell
  crystal build src/ops.cr
  ```
- Run the application:
  ```shell
  ops run
  ```
- Debug mode:
  ```shell
  ops debug
  ```

### Testing
- Run all tests:
  ```shell
  crystal spec
  ```
- Run specific test:
  ```shell
  crystal spec spec/action_spec.cr
  ```
- Run E2E tests:
  ```shell
  ops e2e
  ```

### Linting
- Run rubocop:
  ```shell
  ops lint
  ```

### Release
- Build all targets:
  ```shell
  ops build-all
  ```
- Create a release:
  ```shell
  ops build-release
  ops create-release
  ```

## Configuration

### `ops.yml`

The main configuration file for the `ops` tool. It supports:
- **Dependencies**: Define dependencies for the project (brew, gem, apt, etc.)
- **Forwards**: Create shortcuts for directories (e.g., `gem: rubygem`)
- **Actions**: Define custom commands (e.g., `build`, `test`, `run`)
- **Options**: Configure various behaviors (e.g., `exec.load_secrets`, `gem.use_sudo`)

### Configuration Files

- **`src/app_config.cr`**: Manages loading of configuration files
- **`src/environment.cr`**: Handles environment variable management
- **`src/secrets.cr`**: Manages secrets loading with EJSON

## Key Files

- **`ops.yml`**: Main configuration file
- **`shard.yml`**: Crystal dependencies and project configuration
- **`shard.lock`**: Locked versions of dependencies
- **`Gemfile` and `Gemfile.lock`**: Ruby dependencies for the test suite
- **`CHANGELOG.md`**: Release notes and changes
- **`RELEASE_PROCESS.md`**: Steps for releasing a new version

## Builtins

The tool provides several built-in commands that can be used without defining them in `ops.yml`:

- `countdown <seconds>`: Like `sleep`, but displays time remaining in terminal
- `down [dependency...]`: Unmeets dependencies listed in `ops.yml` (opposite of `up`). Optionally specify which dependencies to unmeet
- `env`: Prints the current environment (e.g. 'dev', 'production', 'staging')
- `envdiff <env1> <env2>`: Compares keys present in config and secrets between different environments
- `exec <command>`: Executes the given command in the `ops` environment, with environment variables set
- `help` (alias: `h`): Displays available builtins, actions, and forwards
- `init [template]`: Creates an `ops.yml` file from a template
- `up [dependency...]`: Attempts to meet dependencies listed in `ops.yml`. Optionally specify which dependencies to meet
- `version` (alias: `v`): Prints the version of `ops` that is running

## Notes

- `crops` does not support the `background` and `background-log` builtins, performance profiling, or the `sshkey.passphrase` option
- The default template directory for `ops init` is `$HOME/.ops_templates`
