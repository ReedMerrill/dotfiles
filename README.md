# Initialization

tuckr operations need to be done from the root of the tuckr project.

on Linux, symlink the `linux` and `shared` groups and run their hooks with:

```bash
tuckr set linux shared
```

For MacOS:

```bash
tuckr set mac shared
```

`tuckr add` only symlinks; `tuckr set` also runs the scripts in `Hooks/<group>/`.

Note: `tuckr` status will return an error about conflicts after running either of the above commands. This is because the app isn't designed to be used to sync dotfiles across different operating systems, so it assumes that all groups will be added on every system. Because of this duplicate paths between groups are flagged as conficts.

# Paths

`tuckr` requires that MacOS uses either an application directory, or `$HOME/.dotfiles`. On Linux, the home path is `$HOME/dotfiles`.

# herdr plugins

herdr has no declarative plugin list, so plugins are pinned to commits in `Hooks/shared/herdr-plugins.txt`. `Hooks/shared/post_herdr_plugins.sh` runs on `tuckr set shared` and installs any plugin that is missing or at a different commit. Plugins already at the pinned commit are skipped. It needs `herdr`, `jq`, `git` and `go` (for the Sesh plugin's build).

To add or update a plugin, either edit the commit in the spec and run the script, or install it by hand with `herdr plugin install` and refresh the pins:

```bash
Hooks/shared/post_herdr_plugins.sh --freeze > Hooks/shared/herdr-plugins.txt
```

Plugin config files (e.g. `plugins/config/fullerzz.sesh/config.toml`) live under `Configs/shared/.config/herdr/` and need a matching exception in `.gitignore`.
