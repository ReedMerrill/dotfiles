To initialize on Linux, symlink the `linux` and `shared` groups with:

```bash
tuckr add linux shared
```

For MacOS, symlink the `mac` and `shared groups:

```bash
tuckr add max shared
```

Note: `tuckr` status will return an error about conflicts after running either of the above commands. This is because the app isn't designed to be used to sync dotfiles across different operating systems, so it assumes that all groups will be added on every system. Because of this duplicate paths between groups are flagged as conficts.
