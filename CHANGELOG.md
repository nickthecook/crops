# crops changelog

> Note: Darwin x86_64 binary is still at 2.0.0.rc12 while I figure out how to build that on my ARM Mac.

## 2.0.0.rc20

- fix version for brew formula

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
