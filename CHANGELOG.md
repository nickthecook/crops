# crops changelog

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
