heka_config 'StatsdInput'

heka_config 'StatAccumInput'

heka_config 'RstEncoder'

heka_config 'Output' do
  config(
    type: 'FileOutput',
    path: '/tmp/hekad.log',
    message_matcher: 'TRUE',
    encoder: 'RstEncoder'
  )
end
