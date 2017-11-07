# 6.1.0 / 2017

* use systemd_unit instead of systemd cookbook
* do nothing on package by default

# 6.0.0 / 2017-07-19

* use systemd v3

# 5.0.0 / 2017-03-08

* switch toml gems

# 4.1.0 / 2016-02-25

* full osx support (yay!)
* use mixed KillMode under systemd

# 4.0.2 / 2016-02-02

* fix delete action

# 4.0.1 / 2016-01-21

* recommended to skip 3.0.1, and go straight to 4.0.1, simplifies upgrade process
* add reload recipe with conditional reload event-handler

# 3.0.1 / 2016-01-20

* big updates: update to heka 0.10.0, change conf root, templatize some things... use caution upgrading.

# 2.0.3 / 2015-10-06

* rebase resources on lwrp base
* simplify service helpers
* update test matrix

# 2.0.2 / 2015-08-19

* fix cops
* notify service to restart on unit change
* add mac_os_x support

# 2.0.1 / 2015-08-19

* fix systemd service definition

# 2.0.0 / 2015-08-19

* change version selection attributes (breaking change!)
* use systemd cookbook to manage systemd service definition
* clean up service provider selection rules

# 1.0.0 / 2015-07-24

* enforce plugin name uniqueness by using chef resource name.
  note that this will break pre-existing configurations by
  requiring (partial) flattening of the config hash

# 0.3.3 / 2015-07-09

* now with TOML 0.4.0 compatibility (thanks @funzoneq!)

# 0.3.2 / 2015-07-06

* update service provider selection

# 0.3.1 / 2015-07-05

* update sysv init file (thanks @jsh2134!)

# 0.3.0 / 2015-05-02

* manage system user/group, run hekad service non-privileged (thanks @jsh2134!)
* pull in sysv script (thanks @jsh2134!) for Ubuntu 1{2,4}.04
* rework service mgmt

# 0.2.3 / 2015-04-23

* update to latest heka bugfix release

# 0.2.2 / 2015-04-16

* fix chef 11 service provider mis-identification

# 0.2.1 / 2015-03-30

* add recipe to help with capturing journald logs via syslog

# 0.2.0/ 2015-03-15

* simplify resource/provider by using toml to encode config

# 0.1.3 / 2015-02-26

* testing improvements
* add support for fedora
* update to latest release

# 0.1.2 / 2015-02-14

* updated docs
* use value_for_platform for package attribute

# 0.1.1 / 2015-02-14

* add heka_config resource

# 0.1.0 / 2015-02-14

* initial release
