require 'spec_helper'

describe HekaConfig::Encoder do
  let(:encoder) do
    HekaConfig::Encoder.new('custom_json_encoder').tap do |r|
      r.type 'SandboxEncoder'
      r.filename 'path/to/custom_json_encoder.lua'
      r.sandbox_config msg_fields: %w( field1 field2 )
    end
  end

  let(:toml) do
    "\n[custom_json_encoder]\nfilename = \"path/to/custom_json_encoder.lua\"\ntype = \"SandboxEncoder\"\n\n[custom_json_encoder.config]\nmsg_fields = [\"field1\",\"field2\"]\n"
  end

  it 'sets a proper encoder toml config' do
    expect(encoder.to_toml).to eq toml
  end
end
