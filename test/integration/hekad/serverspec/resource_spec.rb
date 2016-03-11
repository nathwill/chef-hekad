require 'spec_helper'

describe 'Heka Resources' do
  describe 'configured debug output' do
    describe file('/etc/heka/conf.d/debug_output.toml') do
      its(:content) { should match %r{[debug_output]} }
      its(:content) { should match /encoder = "RstEncoder"/ }
      its(:content) { should match /message_matcher = "TRUE"/ }
      its(:content) { should match %r{path = "/tmp/heka-debug.log"} }
      its(:content) { should match /type = "FileOutput"/ }
      its(:content) { should match /use_buffering = true/ }
      its(:content) { should match %r{[debug_output.buffering]} }
      its(:content) { should match /full_action = "block"/ }
      its(:content) { should match /max_buffer_size = 1073741824/ }
      its(:content) { should match /max_file_size = 1048576/ }
    end
  end

  describe 'configured global config' do
    describe file('/etc/heka/conf.d/hekad.toml') do
      its(:content) { should match %r{[hekad]} }
      its(:content) { should match %r{base_dir = "/var/cache/hekad"} }
      its(:content) { should match /maxprocs = 2/ }
    end
  end

  describe 'configured load avg decoder' do
    describe file('/etc/heka/conf.d/load_avg_decoder.toml') do
      its(:content) { should match %r{[load_avg_decoder]} }
      its(:content) { should match %r{filename = "lua_decoders/linux_loadavg.lua"} }
      its(:content) { should match /type = "SandboxDecoder"/ }
      its(:content) { should match %r{[load_avg_decoder.config]} }
      its(:content) { should match /payload_keep = false/ }
    end
  end

  describe 'configured the load avg filter' do
    describe file('/etc/heka/conf.d/load_avg_filter.toml') do
      its(:content) { should match %r{[load_avg_filter]} }
      its(:content) { should match %r{filename = "lua_filters/loadavg.lua"} }
      its(:content) { should match /preserve_data = true/ }
      its(:content) { should match /ticker_interval = 5/ }
      its(:content) { should match /type = "SandboxFilter"/ }
      its(:content) { should match /use_buffering = true/ }
      its(:content) { should match %r{[load_avg_filter.buffering]} }
      its(:content) { should match /full_action = "block"/ }
      its(:content) { should match /max_buffer_size = 1073741824/ }
      its(:content) { should match /max_file_size = 1048576/ }
      its(:content) { should match %r{[load_avg_filter.config]} }
      its(:content) { should match /preservation_version = 1/ }
    end
  end

  describe 'configured the load avg input' do
    describe file('/etc/heka/conf.d/load_avg_input.toml') do
      its(:content) { should match %r{[load_avg_input]} }
      its(:content) { should match /decoder = "load_avg_decoder"/ }
      its(:content) { should match %r{file_path = "/proc/loadavg"} }
      its(:content) { should match /ticker_interval = 1/ }
      its(:content) { should match /type = "FilePollingInput"/ }
    end
  end

  describe 'configured the my_ip http input' do
    describe file('/etc/heka/conf.d/my_ip.toml') do
      its(:content) { should match %r{[my_ip]} }
      its(:content) { should match /decoder = ""/ }
      its(:content) { should match /error_severity = 1/ }
      its(:content) { should match /success_severity = 6/ }
      its(:content) { should match /ticker_interval = 5/ }
      its(:content) { should match /type = "HttpInput"/ }
      its(:content) { should match %r{url = "https://ipv4.icanhazip.com/"} }
      its(:content) { should match %r{[my_ip.headers]} }
      its(:content) { should match /user-agent = "Mozilla Heka"/ }
    end
  end

  describe 'configured RstEncoder' do
    describe file('/etc/heka/conf.d/RstEncoder.toml') do
      its(:content) { should match %r{[RstEncoder]} }
    end
  end

  describe 'configured splitter' do
    describe file('/etc/heka/conf.d/split_on_space.toml') do
      its(:content) { should match %r{[split_on_space]} }
      its(:content) { should match /delimiter = " "/ }
      its(:content) { should match /deliver_incomplete_final = false/ }
      its(:content) { should match /type = "TokenSplitter"/ }
    end
  end
end
