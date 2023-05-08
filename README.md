# Crystal Ops (crops)

## Differences between `crops` and `ops`

`crops` does not support:

- the `background` builtin (`bg`)
- the `background-log` builtin (`bglog`)
- performance profiling
- the `sshkey.passphrase` option (use `ssh.passphrase_var`; default is `SSH_KEY_PASSPHRASE`)

## Things that are different from `ops` but will be fixed

- `ops init` does not work, because it can't find templates
- "did you mean...?" suggestions
- ~~the user is prompted for the SSH key passphrase if the key requires one, in `ops up sshkey`~~ fixed
- ~~can't handle split custom deps with separate `up` and `down` commands~~ fixed
