require 'spec_helper'

describe HekaConfig::Splitter do
  let(:splitter) do
    HekaConfig::Splitter.new('split_on_space').tap do |r|
      r.type 'TokenSplitter'
      r.deliver_incomplete_final false
      r.config delimiter: ' '
    end
  end

  let(:toml) do
    "\n[split_on_space]\ndelimiter = \" \"\ndeliver_incomplete_final = false\ntype = \"TokenSplitter\"\n"
  end

  it 'sets a proper splitter toml config' do
    expect(splitter.to_toml).to eq toml
  end
end
