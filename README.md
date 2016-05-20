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

Base Heka configuration resource, maps to a file under `/etc/heka.d/`,
allows a free-form configuration hash under the config property.

|Attribute|Description|Default Value|
|---------|-----------|-------------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|

### heka_global

Resource for global configuration section (i.e. the `[hekad]` block).

|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|cpuprof|String. see docs|nil|
|max_message_loops|Integer. see docs|nil|
|max_process_inject|Integer. see docs|nil|
|max_process_duration|Integer. see docs|nil|
|max_timer_inject|Integer. see docs|nil|
|max_pack_idle|String. see docs|nil|
|maxprocs|Integer. see docs|nil|
|memprof|String. see docs|nil|
|poolsize|Integer. see docs|nil|
|plugin_chansize|Integer. see docs|nil|
|base_dir|String. see docs|nil|
|share_dir|String. see docs|nil|
|sample_denominator|Integer. see docs|nil|
|pid_file|String. see docs|nil|
|hostname|String. see docs|nil|
|max_message_size|Integer. see docs|nil|
|log_flags|Integer. see docs|nil|
|full_buffer_max_retries|Integer. see docs|nil|

### heka_input


|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|decoder|String. See docs.|nil|
|synchronous_decode|[TrueClass, FalseClass]. See docs.|nil|
|send_decode_failures|[TrueClass, FalseClass]. See docs.|nil|
|can_exit|[TrueClass, FalseClass]. See docs.|nil|
|splitter|String. See docs.|nil|
|log_decode_failures|[TrueClass, FalseClass]. See docs.|nil|
|script_type|String. See docs.|nil|
|filename|String. See docs.|nil|
|preserve_data|[TrueClass, FalseClass]. See docs.|nil|
|memory_limit|Integer. See docs.|nil|
|instruction_limit|Integer. See docs.|nil|
|output_limit|Integer. See docs.|nil|
|module_directory|String. See docs.|nil|
|sandbox_config|Hash. See docs.|nil|
|server_name|String. See docs.|nil|
|cert_file|String. See docs.|nil|
|key_file|String. See docs.|nil|
|client_auth|String. See docs.|nil|
|ciphers|Array. See docs.|nil|
|insecure_skip_verify|[TrueClass, FalseClass]. See docs.|nil|
|prefer_server_ciphers|[TrueClass, FalseClass]. See docs.|nil|
|session_tickets_disabled|[TrueClass, FalseClass]. See docs.|nil|
|session_ticket_key|String. See docs.|nil|
|min_version|String. See docs.|nil|
|max_version|String. See docs.|nil|
|client_cafile|String. See docs.|nil|
|root_cafile|String. See docs.|nil|
|max_jitter|String. See docs.|nil|
|max_delay|String. See docs.|nil|
|delay|String. See docs.|nil|
|max_retries|Integer. See docs.|nil|

### heka_splitter

|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|keep_truncated|[TrueClass, FalseClass]. See docs.|nil|
|use_message_bytes|[TrueClass, FalseClass]. See docs.|nil|
|min_buffer_size|Integer. See docs.|nil|
|deliver_incomplete_final|[TrueClass, FalseClass]. See docs.|nil|
|max_jitter|String. See docs.|nil|
|max_delay|String. See docs.|nil|
|delay|String. See docs.|nil|
|max_retries|Integer. See docs.|nil|

### heka_decoder

|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|script_type|String. See docs.|nil|
|filename|String. See docs.|nil|
|preserve_data|[TrueClass, FalseClass]. See docs.|nil|
|memory_limit|Integer. See docs.|nil|
|instruction_limit|Integer. See docs.|nil|
|output_limit|Integer. See docs.|nil|
|module_directory|String. See docs.|nil|
|sandbox_config|Hash. See docs.|nil|
|max_jitter|String. See docs.|nil|
|max_delay|String. See docs.|nil|
|delay|String. See docs.|nil|
|max_retries|Integer. See docs.|nil|

### heka_filter

|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|message_matcher|String. See docs.|nil|
|message_signer|String. See docs.|nil|
|ticker_interval|Integer. See docs.|nil|
|can_exit|[TrueClass, FalseClass]. See docs.|nil|
|use_buffering|[TrueClass, FalseClass]. See docs.|nil|
|max_file_size|Integer. See docs.|nil|
|max_buffer_size|Integer. See docs.|nil|
|full_action|String. See docs.|nil|
|cursor_update_count|Integer. See docs.|nil|
|script_type|String. See docs.|nil|
|filename|String. See docs.|nil|
|preserve_data|[TrueClass, FalseClass]. See docs.|nil|
|memory_limit|Integer. See docs.|nil|
|instruction_limit|Integer. See docs.|nil|
|output_limit|Integer. See docs.|nil|
|module_directory|String. See docs.|nil|
|sandbox_config|Hash. See docs.|nil|
|max_jitter|String. See docs.|nil|
|max_delay|String. See docs.|nil|
|delay|String. See docs.|nil|
|max_retries|Integer. See docs.|nil|

### heka_encoder

|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|script_type|String. See docs.|nil|
|filename|String. See docs.|nil|
|preserve_data|[TrueClass, FalseClass]. See docs.|nil|
|memory_limit|Integer. See docs.|nil|
|instruction_limit|Integer. See docs.|nil|
|output_limit|Integer. See docs.|nil|
|module_directory|String. See docs.|nil|
|sandbox_config|Hash. See docs.|nil|
|max_jitter|String. See docs.|nil|
|max_delay|String. See docs.|nil|
|delay|String. See docs.|nil|
|max_retries|Integer. See docs.|nil|

### heka_output

|Attribute|Description|Default|
|---------|-----------|-------|
|path|config base for rendered file|`node['heka']['config_dir']`|
|config|configuration hash|`{}`|
|message_matcher|String. See docs.|nil|
|message_signer|String. See docs.|nil|
|encoder|String. See docs.|nil|
|use_framing|[TrueClass, FalseClass]. See docs.|nil|
|can_exit|[TrueClass, FalseClass]. See docs.|nil|
|use_buffering|[TrueClass, FalseClass]. See docs.|nil|
|script_type|String. See docs.|nil|
|filename|String. See docs.|nil|
|preserve_data|[TrueClass, FalseClass]. See docs.|nil|
|memory_limit|Integer. See docs.|nil|
|instruction_limit|Integer. See docs.|nil|
|output_limit|Integer. See docs.|nil|
|module_directory|String. See docs.|nil|
|sandbox_config|Hash. See docs.|nil|
|max_file_size|Integer. See docs.|nil|
|max_buffer_size|Integer. See docs.|nil|
|full_action|String. See docs.|nil|
|cursor_update_count|Integer. See docs.|nil|
|server_name|String. See docs.|nil|
|cert_file|String. See docs.|nil|
|key_file|String. See docs.|nil|
|client_auth|String. See docs.|nil|
|ciphers|Array. See docs.|nil|
|insecure_skip_verify|[TrueClass, FalseClass]. See docs.|nil|
|prefer_server_ciphers|[TrueClass, FalseClass]. See docs.|nil|
|session_tickets_disabled|[TrueClass, FalseClass]. See docs.|nil|
|session_ticket_key|String. See docs.|nil|
|min_version|String. See docs.|nil|
|max_version|String. See docs.|nil|
|client_cafile|String. See docs.|nil|
|root_cafile|String. See docs.|nil|
|max_jitter|String. See docs.|nil|
|max_delay|String. See docs.|nil|
|delay|String. See docs.|nil|
|max_retries|Integer. See docs.|nil|

--
[chef]: https://www.chef.io/
[docs]: http://hekad.readthedocs.org/
[gc]: http://hekad.readthedocs.org/en/latest/config/index.html#global-configuration-options
