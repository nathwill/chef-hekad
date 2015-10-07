module Heka
  module Init
    def upstart?
      File.executable?('/sbin/initctl')
    end

    def systemd?
      ::IO.read('/proc/1/comm').chomp == 'systemd'
    end

    module_function :upstart?, :systemd?
  end
end
