require 'spec_helper'

describe HekaConfig::Decoder do
  let(:decoder) do
    HekaConfig::Decoder.new('apache_geoip_decoder').tap do |r|
      r.type 'GeoIpDecoder'
      r.config(
        db_file: '/etc/geoip/GeoLiteCity.dat',
        source_ip_field: 'remote_host',
        target_field: 'geoip',
      )
    end
  end

  let(:toml) do
    "\n[apache_geoip_decoder]\ndb_file = \"/etc/geoip/GeoLiteCity.dat\"\nsource_ip_field = \"remote_host\"\ntarget_field = \"geoip\"\ntype = \"GeoIpDecoder\"\n"
  end

  it 'sets a proper decoder toml config' do
    expect(decoder.to_toml).to eq toml
  end

  let(:sandbox_decoder) do
    HekaConfig::Decoder.new('nginx_access_log').tap do |r|
      r.type 'SandboxDecoder'
      r.filename 'lua_decoders/nginx_access.lua'
      r.preserve_data true
      r.sandbox_config(
        type: 'combined',
        user_agent_transform: true,
        log_format: '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"',
      )
    end
  end

  let(:sandbox_toml) do
    "\n[nginx_access_log]\nfilename = \"lua_decoders/nginx_access.lua\"\npreserve_data = true\ntype = \"SandboxDecoder\"\n\n[nginx_access_log.config]\nlog_format = \"$remote_addr - $remote_user [$time_local] \\\"$request\\\" $status $body_bytes_sent \\\"$http_referer\\\" \\\"$http_user_agent\\\"\"\ntype = \"combined\"\nuser_agent_transform = true\n"
  end

  it 'sets a proper sandbox decoder toml config' do
    expect(sandbox_decoder.to_toml).to eq sandbox_toml
  end
end
