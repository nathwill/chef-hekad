module Heka
  module Init
    def upstart?
      File.executable?('/sbin/initctl')
    end

    module_function :upstart?
  end
end

::Chef::Resource.send(:include, Heka::Init)
::Chef::Recipe.send(:include, Heka::Init)
::Chef::Resource.send(:include, Systemd::Helpers::Init)
