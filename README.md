# Crystal Ops (crops)

> This is a port of [`ops`](https://github.com/nickthecook/ops) to Crystal. Versions start at 2.0.0, and the executable is still `ops`.
> `ops` is still available via `gem` as [`ops_team`](https://rubygems.org/gems/ops_team).
> See bottom of file for differences between `crops` and `ops`.

[![Gem Version](https://badge.fury.io/rb/ops_team.svg)](https://badge.fury.io/rb/ops_team)

[View on RubyGems.org](https://rubygems.org/gems/ops_team)

## Overview

`ops` lets you add shell commands to `ops.yml` and run them when you're in that directory. `ops.yml` becomes a context-aware place to add common commands.

![ops.yml excerpt](img/ops_yml.png)

The commands you run to work with your project become discoverable to other devs. You can have different commands in different directories, because `ops` always looks for the `ops.yml` in your current working directory.

![ops t output](img/ops_t.png)

New devs don't need to find which Rakefile contains the task that failed. Just run `ops help`.

![ops help output](img/ops_help.png)

You no longer have to write a shell script for that `curl` command that hits your API in dev, just run `ops create-event`.

![ops create-event output](img/ops_create_event.png)

`ops` will encrypt your SSH keys using a passphrase from an EJSON file, and never prompt you for the passphrase:

![ops up sshkey output](img/ops_up_sshkey.png)

## Dependencies

You can record dependencies for your project in `ops.yml`:

![ops.yml dependencies](img/ops_deps.png)

and `ops up` will satisfy them for you.

![ops up output](img/ops_up_output.png)

## Differences between `crops` and `ops`

`crops` does not support:

- the `background` builtin (`bg`)
- the `background-log` builtin (`bglog`)
- performance profiling
- the `sshkey.passphrase` option (use `ssh.passphrase_var` instead; default is `SSH_KEY_PASSPHRASE`)

The following things are different between `crops` and `ops`:

- default template dir for `ops init` is `$HOME/.ops_templates`; override with option `init.template_dir` or `OPS__INIT__TEMPLATE_DIR`

## Things that are different from `ops` but will be fixed

- "did you mean...?" suggestions
- ~~`ops init` does not work, because it can't find templates~~ fixed
- ~~the user is prompted for the SSH key passphrase if the key requires one, in `ops up sshkey`~~ fixed
- ~~can't handle split custom deps with separate `up` and `down` commands~~ fixed
