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

#### Example

A resource like:

```ruby
heka_config "elasticsearch_output" do
  config(
    type: "ElasticSearchOutput",
    message_matcher: "TRUE",
    can_exit: false,
    encoder: "elasticsearch_json_encoder",
    use_buffering: false,
    buffering: {
      max_file_size: 10_485_760, # 10MiB
      max_buffer_size: 104_857_600, # 100MiB
      full_action: "block"
    },
    server: "http://1.2.3.4:9201"
  )
end
```

will render a config like:

```toml
[elasticsearch_output]
can_exit = false
encoder = "elasticsearch_json_encoder"
message_matcher = "TRUE"
server = "http://1.2.3.4:9201"
type = "ElasticSearchOutput"
use_buffering = false
[elasticsearch_output.buffering]
full_action = "block"
max_buffer_size = 104857600
max_file_size = 10485760
```

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

#### Example

A resource like:

```ruby
heka_global 'hekad' do
  maxprocs 2
  base_dir '/var/cache/hekad'
  full_buffer_max_retries 5
end
```

will render a config like:

```toml
[hekad]
base_dir = "/var/cache/hekad"
full_buffer_max_retries = 5
maxprocs = 2
```

### heka_input

Resource for configuring input plugins

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

#### Example

A resource like:

```ruby
heka_input 'load_avg_input' do
  type 'FilePollingInput'
  decoder 'load_avg_decoder'
  config file_path: '/proc/loadavg', ticker_interval: 1
end
```

will render a config like:

```toml
[load_avg_input]
decoder = "load_avg_decoder"
file_path = "/proc/loadavg"
ticker_interval = 1
type = "FilePollingInput"
```

### heka_splitter

Resource for configuring splitter plugins.

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

#### Example

A resource like:

```ruby
heka_splitter 'split_on_space' do
  type 'TokenSplitter'
  deliver_incomplete_final false
  config delimiter: ' '
end
```

will render a config like:

```toml
[split_on_space]
delimiter = " "
deliver_incomplete_final = false
type = "TokenSplitter"
```

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

#### Example

A resource like:

```ruby
heka_decoder 'load_avg_decoder' do
  type 'SandboxDecoder'
  filename 'lua_decoders/linux_loadavg.lua'
  sandbox_config payload_keep: false
end
```

will render a config like:

```toml
[load_avg_decoder]
filename = "lua_decoders/linux_loadavg.lua"
type = "SandboxDecoder"
[load_avg_decoder.config]
payload_keep = false
```

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

#### Example

A resource like:

```ruby
heka_filter 'load_avg_filter' do
  type 'SandboxFilter'
  filename 'lua_filters/loadavg.lua'
  ticker_interval 5
  preserve_data true
  message_matcher "Type == 'stats.loadavg'"
  sandbox_config preservation_version: 1
  use_buffering true
  buffering_config do
    max_file_size 1024 ** 2
    max_buffer_size 1024 ** 3
    full_action 'block'
  end
end
```

will render a config like:

```toml
[load_avg_filter]
filename = "lua_filters/loadavg.lua"
message_matcher = "Type == 'stats.loadavg'"
preserve_data = true
ticker_interval = 5
type = "SandboxFilter"
use_buffering = true
[load_avg_filter.buffering]
full_action = "block"
max_buffer_size = 1073741824
max_file_size = 1048576
[load_avg_filter.config]
preservation_version = 1
```

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

#### Example

A resource like:

```ruby
heka_encoder 'RstEncoder' { type 'RstEncoder' }
```

will render a config like:

```toml
[RstEncoder]
```

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

#### Example

A resource like:

```ruby
heka_output 'debug_output' do
  type 'FileOutput'
  message_matcher 'TRUE'
  encoder 'RstEncoder'
  config path: '/tmp/heka-debug.log'
  use_buffering  true
  buffering_config do
    max_file_size 1024 ** 2
    max_buffer_size 1024 ** 3
    full_action 'block'
  end
end
```

will render a config like:

```toml
[debug_output]
encoder = "RstEncoder"
message_matcher = "TRUE"
path = "/tmp/heka-debug.log"
type = "FileOutput"
use_buffering = true
[debug_output.buffering]
full_action = "block"
max_buffer_size = 1073741824
max_file_size = 1048576
```

--
[chef]: https://www.chef.io/
[docs]: http://hekad.readthedocs.org/
[gc]: http://hekad.readthedocs.org/en/latest/config/index.html#global-configuration-options
