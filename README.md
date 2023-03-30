# Crystal Ops (crops)

## Differences between `crops` and `ops`

`crops` does not support:

- the `countdown` builtin (`cd`)
- the `background` builtin (`bg`)
- the `background-log` builtin (`bglog`)
- performance profiling
- "did you mean...?" suggestions
- the `sshkey.passphrase` option (use `ssh.passphrase_var`)

## Things that are different from `ops` but will be fixed

- the user is prompted for the SSH key passphrase if the key requires one, in `ops up sshkey`
