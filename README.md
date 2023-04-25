# Crystal Ops (crops)

## Differences between `crops` and `ops`

`crops` does not support:

- the `background` builtin (`bg`)
- the `background-log` builtin (`bglog`)
- performance profiling
- "did you mean...?" suggestions
- the `sshkey.passphrase` option (use `ssh.passphrase_var`; default is `SSH_KEY_PASSPHRASE`)

## Things that are different from `ops` but will be fixed

- ~~the user is prompted for the SSH key passphrase if the key requires one, in `ops up sshkey`~~ fixed
- ~~can't handle split custom deps with separate `up` and `down` commands~~ fixed
