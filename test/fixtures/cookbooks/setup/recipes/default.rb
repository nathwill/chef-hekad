
heka_input 'http_input' do
  type 'HttpListenInput'
  decoder 'json_decoder'
  can_exit false
  log_decode_failures false
  send_decode_failures true
  config address: '127.0.0.1:8325'
end

heka_decoder 'json_decoder' do
  type 'SandboxDecoder'
  filename 'lua_decoders/json.lua'
  preserve_data true
  sandbox_config payload_keep: false, map_fields: false
end

heka_filter 'counter' do
  type 'CounterFilter'
  message_matcher 'TRUE'
  can_exit false
  ticker_interval 5
  use_buffering false
end

heka_encoder 'RstEncoder'

heka_output 'log_output' do
  type 'FileOutput'
  message_matcher 'TRUE'
  encoder 'RstEncoder'
  can_exit false
  use_buffering true
  full_action 'block'
  config path: '/var/tmp/heka-out.log', perm: '644'
end
