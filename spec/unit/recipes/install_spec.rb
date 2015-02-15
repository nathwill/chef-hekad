require 'spec_helper'

describe 'hekad::install' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'installs the package' do
      expect(chef_run).to install_package 'heka'
    end
  end
end
