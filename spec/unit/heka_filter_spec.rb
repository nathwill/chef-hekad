require 'spec_helper'

describe HekaConfig::Filter do
  let(:filter) do
    HekaConfig::Filter.new('FxaDailyActiveUsers').tap do |r|
      r.type 'SandboxFilter'
      r.filename 'lua_filters/unique_items.lua'
      r.message_matcher "Logger == 'FxaAuth'"
      r.ticker_interval 60
      r.preserve_data true
      r.sandbox_config(
        message_variable: 'Fields[uid]',
        title: 'Estimated Daily Active Users',
        preservation_version: 0,
      )
      r.use_buffering true
      r.max_file_size(1_024 ** 3)
      r.full_action 'block'
      r.max_buffer_size(1_024 ** 4)
    end
  end

  let(:toml) do
    "\n[FxaDailyActiveUsers]\nfilename = \"lua_filters/unique_items.lua\"\nmessage_matcher = \"Logger == 'FxaAuth'\"\npreserve_data = true\nticker_interval = 60\ntype = \"SandboxFilter\"\nuse_buffering = true\n\n[FxaDailyActiveUsers.buffering]\nfull_action = \"block\"\nmax_buffer_size = 1099511627776\nmax_file_size = 1073741824\n\n[FxaDailyActiveUsers.config]\nmessage_variable = \"Fields[uid]\"\npreservation_version = 0\ntitle = \"Estimated Daily Active Users\"\n"
  end

  it 'sets proper filter config' do
    expect(filter.to_toml).to eq toml
  end
end
