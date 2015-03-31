#
# Cookbook Name:: hekad
# Recipe:: systemd
#
# Copyright 2015 Nathan Williams <nath.e.will@gmail.com>
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

%w( luarocks lua-devel systemd-devel ).each do |pkg|
  package pkg
end

execute 'install-lua-systemd-bindings' do
  command 'luarocks install --server=http://rocks.moonscript.org/manifests/daurnimator systemd'
end

directory '/usr/share/heka/lua_inputs'

cookbook_file '/usr/share/heka/lua_inputs/systemd_journal.lua' do
  source 'systemd_journal.lua'
end

heka_config 'journal' do
  config {

  }
end
