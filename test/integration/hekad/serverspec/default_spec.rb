require 'spec_helper'

describe 'heka::default' do
  describe 'is installed' do
    describe package('heka'), :unless => os[:family] == 'darwin' do
      it { should be_installed }
    end

    describe command('/usr/local/bin/brew cask list'), :if => os[:family] == 'darwin' do
      its(:stdout) { should match /heka/ }
    end
  end

  describe 'is configured' do
    describe file('/etc/heka/conf.d') do
      it { should be_directory }
    end

    describe file('/etc/heka/conf.d/hekad.toml') do
      its(:content) { should match /\[hekad\]/ }
      its(:content) { should match /maxprocs = 2/ }
    end

    describe service('hekad') do
      it { should be_running }
    end
  end
end
