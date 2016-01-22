# hekad cookbook [![Build Status](https://travis-ci.org/nathwill/chef-hekad.svg?branch=master)](https://travis-ci.org/nathwill/chef-hekad)

A [Chef][chef] cookbook for installing & configuring [Mozilla Heka][docs].

## Recipes

### hekad::default

Includes the install, configure, and service recipes.

### hekad::install

Downloads the configured release, and installs it.

### hekad::configure

Creates the configuration template directory, and installs the
`heka_config[hekad]` resource, with hekas [global configuration][gc].

See attributes documentation about how to set global configuration.

### hekad::service

Installs and configures a heka user, group, and service.

## Attributes

Attributes are namespaced under `default['heka']`.

|Attribute|Description|Default Value|
|---------|-----------|-------------|
|config_dir|base path for configs|`/etc/heka/conf.d`|
|config|default global configuration|`maxprocs: 2`|
|package_url|url for release pkg|varies by platform|

## Resources

### heka_config

Heka configuration, maps to a file under `/etc/heka.d/`.

|Attribute|Description|Default Value|
|---------|-----------|-------------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|

[chef]: https://www.chef.io/
[docs]: http://hekad.readthedocs.org/
[gc]: http://hekad.readthedocs.org/en/latest/config/index.html#global-configuration-options
