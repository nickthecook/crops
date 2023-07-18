# crops changelog

> Note: Darwin x86_64 binary is 2.1.2

## 2.1.3 (gem 2.1.3.rc1)

- add aliases for Builtins, to clean up `help` output
- update Darwin x86_64 binary to 2.1.2

## 2.1.2 (gem 2.1.2.rc1)

- don't prompt for passphrase on `ops up sshkey` when passphrase variable is not set
- don't require ops.yml for `--help`, `h`, `-h`, `--version`, `v`, `-v`

## 2.1.1 (gem 2.1.1.rc1)

- limit to GNU-style short and long option args

## 2.1.0 (gem 2.1.0.rc1)

- when an action exists with the same name as a builtin, the action will now override the builtin
- allow using `--` to invoke builtins, even when an overriding action is defined

## 2.0.8 (gem 2.0.8.rc1)

- fix bug in envdiff when ignored_keys option is set

## 2.0.7 (gem 2.0.7.rc1)

- fix bug with split `custom` dependencies that only define `up` or `down` where `ops` would exit with an error

## 2.0.6 (gem 2.0.6.rc1)

- `ops init` will now accept the path to a file as a template name

## 2.0.5

- change Homebrew formula to build release binary (it's smaller)

## 2.0.4.rc2 gem

- add ejson as dependency in the gem

## 2.0.4 (gem 2.0.4.rc1)

- fix 2.0.3 reporting the wrong version

## 2.0.3

- fix bug in which ops would not find `ops.yaml` when invoked by a forward

## 2.0.2 (2.0.2.rc1 - gem)

- fix bug in which empty top-level sections of ops.yml would cause ops to exit with an error

## 2.0.1 (2.0.1.rc1 - gem)

- fix bug in which `shell_expansion: false` would split args that contained spaces

## 2.0.0

- release as stable

## 2.0.0.rc20

- fix version for brew formula
- update Darwin Intel binary

## 2.0.0.rc19

- support loading encrypted SSH private keys when permissions are not 0600
  - `git` only tracks the executable bit, so the default for an encrypted, checked-in key will be 644 after clone

## 2.0.0.rc18

- update linux binary (only Darwin x86_64 is not updated now)

## 2.0.0.rc17

- support user template dir
  - "$HOME/.ops_templates" by default
  - set with option `init.template_dir` or `OPS__INIT__TEMPLATE_DIR`
  - can be relative path or absolute

## 2.0.0.rc16

- exit with non-zero status if ops.yml doesn't exist for builtins that require it
  - builtins that DO NOT require ops.yml: ["init", "version", "help", "env", "envdiff", "exec"]
- fix `ops init` for built-in templates ("ops", "terraform", "ruby")

## 2.0.0.rc15

- remove debug print statement

## 2.0.0.rc14

- [prefer `ops.yaml` over `ops.yml`](https://yaml.org/faq.html)

## 2.0.0.rc12

- this is 0.3.1

## 0.3.1

- fix issue with YAML converting strings to bools when custom dependency command is `true` or `false`

## 0.3.0

- add support for split custom dependencies

## 0.2.0

- output version with name, i.e. `crops-x.y.x`, to distinguish from Ruby `ops`

## 0.1.1

- tweak to ssh key generation without a passphrase

## 0.1.0

- first mostly working version

## 0.0.1

- doesn't compile
