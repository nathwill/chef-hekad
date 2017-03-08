require 'spec_helper'

describe HekaConfig::Input do
  let(:input) do
    HekaConfig::Input.new('load_avg_input').tap do |r|
      r.type 'FilePollingInput'
      r.decoder 'load_avg_decoder'
      r.config file_path: '/proc/loadavg', ticker_interval: 1
    end
  end

  let(:toml) do
    "\n[load_avg_input]\ndecoder = \"load_avg_decoder\"\nfile_path = \"/proc/loadavg\"\nticker_interval = 1\ntype = \"FilePollingInput\"\n"
  end

  it 'generates a proper toml string' do
    expect(input.to_toml).to eq toml
  end

  let(:tls_input) do
    HekaConfig::Input.new('tls_input').tap do |r|
      r.type 'HttpListenInput'
      r.config address: '0.0.0.0:8325'
      r.use_tls true
      r.cert_file '/usr/share/heka/tls/cert.pem'
      r.key_file '/usr/share/heka/tls/cert.key'
      r.prefer_server_ciphers true
      r.min_version 'TLS11'
    end
  end

  let(:tls_toml) do
    "\n[tls_input]\naddress = \"0.0.0.0:8325\"\ntype = \"HttpListenInput\"\nuse_tls = true\n\n[tls_input.tls]\ncert_file = \"/usr/share/heka/tls/cert.pem\"\nkey_file = \"/usr/share/heka/tls/cert.key\"\nmin_version = \"TLS11\"\nprefer_server_ciphers = true\n"
  end

  it 'configures a tls subsection' do
    expect(tls_input.to_toml).to eq tls_toml
  end

  let(:sandbox_input) do
    HekaConfig::Input.new('sandbox_input').tap do |r|
      r.type 'SandboxInput'
      r.filename 'lua_inputs/my_input.lua'
      r.sandbox_config preserve_payload: false
    end
  end

  let(:sandbox_toml) do
    "\n[sandbox_input]\nfilename = \"lua_inputs/my_input.lua\"\ntype = \"SandboxInput\"\n\n[sandbox_input.config]\npreserve_payload = false\n"
  end

  it 'generates a proper sandbox config' do
    expect(sandbox_input.to_toml).to eq sandbox_toml
  end
end
