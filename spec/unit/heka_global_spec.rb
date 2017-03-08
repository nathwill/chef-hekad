require 'spec_helper'

describe HekaConfig::Global do
  let(:global) do
    HekaConfig::Global.new('hekad').tap do |r|
      r.maxprocs 2
      r.base_dir '/var/cache/heka'
      r.log_flags 0
    end
  end

  let(:toml) do
    "\n[hekad]\nbase_dir = \"/var/cache/heka\"\nlog_flags = 0\nmaxprocs = 2\n"
  end

  it 'sets a proper global toml config' do
    expect(global.to_toml).to eq toml
  end
end
