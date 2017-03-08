require 'spec_helper'

describe HekaConfig::Output do
  let(:output) do
    HekaConfig::Output.new('elasticsearch_output').tap do |r|
      r.type 'ElasticSearchOutput'
      r.message_matcher "Type == 'logfile'"
      r.encoder 'es_json_encoder'
      r.config server: 'http://es-server:9200'
      r.use_buffering true
      r.max_file_size(1_024 ** 3)
      r.full_action 'block'
    end
  end

  let(:toml) do
    "\n[elasticsearch_output]\nencoder = \"es_json_encoder\"\nmessage_matcher = \"Type == 'logfile'\"\nserver = \"http://es-server:9200\"\ntype = \"ElasticSearchOutput\"\nuse_buffering = true\n\n[elasticsearch_output.buffering]\nfull_action = \"block\"\nmax_file_size = 1073741824\n"
  end

  it 'sets a proper output toml config' do
    expect(output.to_toml).to eq toml
  end

  let(:tls_output) do
    HekaConfig::Output.new('amqp_output').tap do |r|
      r.type 'AMQPOutput'
      r.config(
        url: 'amqp://guest:guest@rabbitmq/',
        exchange: 'testout',
        exchange_type: 'fanout',
      )
      r.message_matcher "Logger == 'TestWebserver'"
      r.use_tls true
      r.cert_file '/usr/share/heka/tls/cert.pem'
      r.key_file '/usr/share/heka/tls/cert.key'
      r.prefer_server_ciphers true
      r.min_version 'TLS11'
    end
  end

  let(:tls_toml) do
    "\n[amqp_output]\nexchange = \"testout\"\nexchange_type = \"fanout\"\nmessage_matcher = \"Logger == 'TestWebserver'\"\ntype = \"AMQPOutput\"\nurl = \"amqp://guest:guest@rabbitmq/\"\nuse_tls = true\n\n[amqp_output.tls]\ncert_file = \"/usr/share/heka/tls/cert.pem\"\nkey_file = \"/usr/share/heka/tls/cert.key\"\nmin_version = \"TLS11\"\nprefer_server_ciphers = true\n"
  end

  it 'sets a proper tls output config' do
    expect(tls_output.to_toml).to eq tls_toml
  end

  let(:sandbox_output) do
    HekaConfig::Output.new('redis_output').tap do |r|
      r.type 'SandboxOutput'
      r.filename 'lua_outputs/redis.lua'
      r.preserve_data true
      r.sandbox_config channel: 'heka-output', encoding: 'json'
    end
  end

  let(:sandbox_toml) do
    "\n[redis_output]\nfilename = \"lua_outputs/redis.lua\"\npreserve_data = true\ntype = \"SandboxOutput\"\n\n[redis_output.config]\nchannel = \"heka-output\"\nencoding = \"json\"\n"
  end

  it 'sets proper sandbox toml config' do
    expect(sandbox_output.to_toml).to eq sandbox_toml
  end
end
