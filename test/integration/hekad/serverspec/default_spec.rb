require 'spec_helper'

describe 'heka::default' do
  describe 'is installed' do
    describe package('heka') do
      it { should be_installed }
    end
  end

  describe 'is configured' do
    describe file('/etc/heka') do
      it { should be_directory }
    end

    describe file('/etc/heka/hekad.toml') do
      its(:content) { should match /\[hekad\]/ }
      its(:content) { should match /maxprocs = 2/ }
    end

    describe service('hekad') do
      it { should be_running }
    end

    describe file('/var/log/hekad-journal.log'), :if => os[:family] =~ /(fedora|rhel)/ do
      its(:content) { should match /journald_syslog/ }
    end
  end
end
