# Crystal Ops (crops)

## Differences between `crops` and `ops`

`crops` does not support:

- the `background` builtin (`bg`)
- the `background-log` builtin (`bglog`)
- performance profiling
- the `sshkey.passphrase` option (use `ssh.passphrase_var`; default is `SSH_KEY_PASSPHRASE`)
- default template dir for `ops init` is `$HOME/.ops_templates`; override with option `init.template_dir` or `OPS__INIT__TEMPLATE_DIR`

## Things that are different from `ops` but will be fixed

- "did you mean...?" suggestions
- ~~`ops init` does not work, because it can't find templates~~ fixed
- ~~the user is prompted for the SSH key passphrase if the key requires one, in `ops up sshkey`~~ fixed
- ~~can't handle split custom deps with separate `up` and `down` commands~~ fixed
