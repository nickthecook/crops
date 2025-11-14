# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is `crops` (Crystal Ops) - a port of the Ruby `ops` tool to Crystal. It's a context-aware command runner that reads `ops.yml` files to provide discoverable shortcuts for project-specific shell commands, dependency management, secrets loading, and configuration management.

## Build and Test Commands

### Development workflow
```bash
# Build debug binary (fast, for development)
ops build-debug
# Output: bin/ops

# Run without building (development)
ops run <command>

# Run with debug output
ops debug <command>

# Build release binary (optimized)
ops build
# Output: build/<platform>/ops

# Install to $HOME/bin/ (or $INSTALL_DIR)
ops install
```

### Testing
```bash
# Run Crystal unit tests
ops test  # alias: ops t

# Run e2e tests (RSpec-based integration tests)
ops test-e2e  # alias: ops e2e
# This builds a debug binary and runs RSpec against it

# Watch mode for development
ops test-watch      # alias: ops tw (Crystal specs)
ops test-e2e-watch  # alias: ops ew (E2E specs)
ops run-watch       # alias: ops rw (auto-restart on file changes)
```

### Other development commands
```bash
ops lint                    # Run rubocop (for RSpec tests)
ops build-all              # Build for all platforms and create release tarballs
ops platform               # Show current platform (e.g., darwin_arm64)
shards install             # Install Crystal dependencies
bundle                     # Install Ruby gems (for E2E tests)
```

## Code Architecture

### Core execution flow

The main entry point is `ops.cr` which:
1. Parses CLI flags (`-f`/`--file` for custom config, `-q`/`--quiet`)
2. Instantiates `Ops` class with the action name and arguments
3. `Ops.run` checks min_version requirement, then delegates to `Runner`

**`Runner` (src/runner.cr)** is the execution dispatcher:
- First checks if action is a **forward** (alias to another directory's ops.yml)
- Then loads **AppConfig** (config/\$environment/config.{yml,yaml,json})
- Loads **Secrets** (config/\$environment/secrets.ejson) if action requires it
- Sets environment variables from `options.environment` in ops.yml
- Executes **before hooks** (unless OPS_RUNNING env var is set)
- Dispatches to either an **Action** (from ops.yml) or a **Builtin**

### Configuration system

**`OpsYml` (src/ops_yml.cr)** parses ops.yml:
- `actions`: User-defined commands
- `dependencies`: Things to install/satisfy
- `forwards`: Directory aliases
- `hooks`: Before/after action hooks
- `options.environment`: Env vars to set
- `min_version`: Required ops version

**Environment variable loading order** (later sources override earlier):
1. AppConfig (config/\$environment/config.{yml,yaml,json})
2. Secrets (config/\$environment/secrets.ejson) - only if action has `load_secrets: true`
3. Options.environment (from ops.yml)

### Actions vs Builtins

**Actions** (src/action.cr):
- Defined in ops.yml under `actions:`
- Support `shell_expansion` (default true) and `param_expansion` (default false)
- Can have `alias`, `aliases`, `description`, `load_secrets`, `in_envs`, `not_in_envs`, `skip_in_envs`
- Executed via `Process.exec` or through `Interpreter` (for param expansion)

**Builtins** (src/builtins/):
- Hard-coded commands: help, version, up, down, init, env, envdiff, exec, countdown, encrypt
- Live in `src/builtins/*.cr`, inherit from `Builtins::Builtin`
- Registered in `src/builtins/builtins.cr` via `class_for(name:)` method

### Dependencies system

**Dependencies** (src/dependencies/):
- Each type is a class: Brew, Apt, Apk, Gem, Pip, Cask, Docker, Custom, Dir, Sshkey, Snap
- All inherit from `Dependencies::Dependency`
- `up` builtin iterates and calls `.meet` on each
- `down` builtin calls `.unmeet` on each
- SSH keys can be encrypted with a passphrase from env var (default: `SSH_KEY_PASSPHRASE`)

## E2E Testing System

Tests are RSpec-based and live in `spec/e2e/`. There are 41 test directories.

**Key files:**
- `spec/spec_helper.rb`: Sets environment=test, EJSON_KEYDIR, runs each spec from its own directory via `Dir.chdir`, cleans up untracked files before each test, clears SSH keys after suite
- `spec/e2e/e2e_spec_helper.rb`: Provides `"ops e2e"` shared context with `ops(cmd)` helper that walks up to find `bin/ops` and returns `[output, output_file, exit_status]`

**Writing an e2e test:**
```ruby
RSpec.describe "feature name" do
  let(:commands) { ["action-name"] }  # Single command
  # OR
  let(:commands) { ["cmd1", "cmd2"] }  # Multiple commands

  include_context "ops e2e"

  it "succeeds" do
    expect(exit_code).to eq(0)
  end

  it "outputs expected text" do
    expect(output).to match(/some text/)
  end
end
```

Each test runs in isolation in its own directory with its own `ops.yml`. Tests can assert on exit codes, stdout/stderr (via `output`/`outputs`), file states, or system state (e.g., SSH agent).

## Important patterns

### Environment variable options
All options in ops.yml can be overridden via environment variables using double-underscore notation:
```bash
OPS__EXEC__LOAD_SECRETS=true ops exec mycommand
```

### Crystal idioms used in this codebase
- Nil-safety: `l_config = config` pattern to unwrap nilable types
- `@ivar ||= begin ... end` for lazy initialization
- `YamlUtil` helpers to safely convert YAML::Any to Crystal types
- `Output.debug`, `Output.notice`, `Output.warn`, `Output.error` for logging

### Error handling
`Ops.run` rescues specific exception types and returns appropriate exit codes:
- MIN_VERSION_NOT_MET_EXIT_CODE = 67
- UNKNOWN_ACTION_EXIT_CODE = 65
- ACTION_CONFIG_ERROR_EXIT_CODE = 68
- BUILTIN_SYNTAX_ERROR_EXIT_CODE = 69
- And others (see src/ops.cr:10-20)

## Platform-specific notes

- Homebrew (brew, cask) dependencies only run on macOS
- APT dependencies only run on Debian-based Linux
- APK dependencies only run on Alpine Linux
- Build targets: darwin_arm64, darwin_x86_64, linux_x86_64 (see ops.yml:14-17)
- Use `ops platform` to see current platform identifier
