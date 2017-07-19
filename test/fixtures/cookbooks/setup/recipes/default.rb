# Test misc heka resources
heka_config 'my_ip' do
  config(
    type: 'HttpInput',
    url: 'https://ipv4.icanhazip.com/',
    ticker_interval: 5,
    success_severity: 6,
    error_severity: 1,
    decoder: "",
    headers: { 'user-agent' => 'Mozilla Heka' },
  )
end

heka_splitter 'split_on_space' do
  type 'TokenSplitter'
  deliver_incomplete_final false
  config delimiter: ' '
end

heka_input 'load_avg_input' do
  type 'FilePollingInput'
  decoder 'load_avg_decoder'
  config file_path: '/proc/loadavg', ticker_interval: 1
end

heka_decoder 'load_avg_decoder' do
  type 'SandboxDecoder'
  filename 'lua_decoders/linux_loadavg.lua'
  sandbox_config payload_keep: false
end

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

heka_encoder 'RstEncoder' do
  type 'RstEncoder'
end

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
