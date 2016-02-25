#
# Cookbook Name:: hekad
# Library:: Heka::Init
#
# Copyright 2016 Nathan Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Heka
  module Init
    def upstart?
      File.executable?('/sbin/initctl')
    end

    def systemd?
      ::File.exist?('/proc/1/comm') &&
        ::IO.read('/proc/1/comm').chomp == 'systemd'
    end

    module_function :upstart?, :systemd?
  end
end
