require 'spec_helper'

describe HekaConfig::Base do
  let(:heka_config) do
    HekaConfig::Base.new('my_ip').tap do |r|
      r.config(
        type: 'HttpInput',
        url: 'https://ipv4.icanhazip.com',
        ticker_interval: 5,
        success_severity: 6,
        error_severity: 1,
        decoder: "",
        headers: { 'user-agent' => 'Mozilla Heka' },
      )
    end
  end

  let(:config) do
    "\n[my_ip]\ndecoder = \"\"\nerror_severity = 1\nsuccess_severity = 6\nticker_interval = 5\ntype = \"HttpInput\"\nurl = \"https://ipv4.icanhazip.com\"\n\n[my_ip.headers]\nuser-agent = \"Mozilla Heka\"\n"
  end

  it 'generates proper toml config' do
    expect(heka_config.to_toml).to eq config
  end
end
