# Changelog

### master
- enable overriding default key bindings
- start using `C-c` to clear screen

### v1.2.2, 2015-02-08
- set GIT_TERMINAL_PROMPT=0 when doing `git clone`, `pull` or `submodule update`
  to ensure git does not prompt for username/password in any case

### v1.2.1, 2014-11-21
- change the way plugin name is expanded. It now uses the http username
  and password by default, like this: `https://git::@github.com/`. This prevents
  username and password prompt (and subsequently tmux install hanging) with old
  git versions. Fixes #7.

### v1.2.0, 2014-11-20
- refactor tests so they can be used on travis
- add travis.yml, add travis badge to the readme

### v1.1.0, 2014-11-19
- if the plugin is not downloaded do not source it
- remove `PLUGINS.md`, an obsolete list of plugins
- update readme with instructions about uninstalling plugins
- tilde char and `$HOME` in `TMUX_SHARED_MANAGER_PATH` couldn't be used because
  they are just plain strings. Fixing the problem by manually expanding them.
- bugfix: fragile `*.tmux` file globbing (@majutsushi)

### v1.0.0, 2014-08-05
- update readme because of github organization change to
  [tmux-plugins](https://github.com/tmux-plugins)
- update tests to pass
- update README to suggest different first plugin
- update list of plugins in the README
- remove README 'about' section
- move key binding to the main file. Delete `key_binding.sh`.
- rename `display_message` -> `echo_message`
- installing plugins installs just new plugins. Already installed plugins aren't
  updated.
- add 'update plugin' binding and functionality
- add test for updating a plugin

### v0.0.2, 2014-07-17
- run all *.tmux plugin files as executables
- fix all redirects to /dev/null
- fix bug: TPM shared path is created before sync (cloning plugins from github
  is done)
- add test suite running in Vagrant
- add Tmux version check. `TPM` won't run if Tmux version is less than 1.9.

### v0.0.1, 2014-05-21
- get TPM up and running
