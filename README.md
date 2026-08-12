# Initialization

tuckr operations need to be done from the root of the tuckr project.

on Linux, symlink the `linux` and `shared` groups with:

```bash
tuckr add linux shared
```

For MacOS:

```bash
tuckr add mac shared
```

Note: `tuckr` status will return an error about conflicts after running either of the above commands. This is because the app isn't designed to be used to sync dotfiles across different operating systems, so it assumes that all groups will be added on every system. Because of this duplicate paths between groups are flagged as conficts.

# Paths

`tuckr` requires that MacOS uses either an application directory, or `$HOME/.dotfiles`. On Linux, the home path is `$HOME/dotfiles`.
