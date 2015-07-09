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

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>release_url</td>
      <td>
        base url for download path
      </td>
      <td><code>https://github.com/mozilla-services/heka/releases/download</code></td>
    </tr>
    <tr>
      <td>version</td>
      <td>
        heka release version
      </td>
      <td><code>0.8.3</code></td>
    </tr>
    <tr>
      <td>tag</td>
      <td>
        heka release tag
      </td>
      <td><code>v0.8.3</code></td>
    </tr>
    <tr>
      <td>package</td>
      <td>
        heka release package
      </td>
      <td><code>heka-0_8_3-linux-amd64.rpm or heka_0.8.3_amd64.deb</code></td>
    </tr>
    <tr>
      <td>config</td>
      <td>
        heka global configuration (Hash)
      </td>
      <td><code>{'maxprocs' => 2, 'pid_file' => '/var/run/hekad.pid'}</code></td>
    </tr>
  </tbody>
</table>

## Resources

### heka_config

Heka configuration, maps to a file under /etc/heka.

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>path</td>
      <td>
        Filesystem location for the rendered config template.
      </td>
      <td><code>/etc/heka/$name.toml</code></td>
    </tr>
    <tr>
      <td>config</td>
      <td>
        ruby Hash that will be toml-encoded and written to /etc/heka/$name.toml
      </td>
      <td><code>{}</code></td>
    </tr>
  </tbody>
</table>

[chef]: https://www.chef.io/
[docs]: http://hekad.readthedocs.org/
[gc]: http://hekad.readthedocs.org/en/latest/config/index.html#global-configuration-options
