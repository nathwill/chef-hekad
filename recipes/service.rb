#
# Cookbook Name:: hekad
# Recipe:: service
#
# Copyright 2015 Nathan Williams
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

group node['heka']['user'] do
  system true
  action :create
end

user node['heka']['user'] do
  shell '/bin/false'
  system true
  gid node['heka']['user']
  action :create
end

directory node['heka']['config']['base_dir'] do
  owner node['heka']['user']
  group node['heka']['user']
  recursive true
  action :create
end

# systemd
systemd_unit 'hekad.service' do
  content(
    Unit: {
      Description: 'general purpose data acquisition and processing engine',
      Documentation: 'https://hekad.readthedocs.io'
    },
    Service: {
      User: node['heka']['user'],
      Group: node['heka']['user'],
      ExecStart: "/usr/bin/hekad -config=#{node['heka']['config_dir']}",
      Restart: 'on-failure',
      KillMode: 'mixed'
    },
    Install: {
      WantedBy: 'multi-user.target'
    }
  )
  only_if { Heka::Init.systemd? }
  notifies :restart, 'service[hekad]', :delayed
  action :create
end

# upstart
template '/etc/init/hekad.conf' do
  source 'hekad.conf'
  variables user: node['heka']['user'], conf_dir: node['heka']['config_dir']
  only_if { Heka::Init.upstart? }
  notifies :restart, 'service[hekad]', :delayed
  action :create
end

# sysv
template '/etc/init.d/hekad' do
  source 'hekad.sysv'
  mode '0755'
  variables user: node['heka']['user'], conf_dir: node['heka']['config_dir']
  not_if { Heka::Init.systemd? || Heka::Init.upstart? || platform?('mac_os_x') }
  notifies :restart, 'service[hekad]', :delayed
  action :create
end

# launchd
template '/Library/LaunchDaemons/hekad.plist' do
  source 'hekad.plist'
  mode '0644'
  variables user: node['heka']['user'], conf_dir: node['heka']['config_dir']
  only_if { platform?('mac_os_x') }
  notifies :restart, 'service[hekad]', :delayed
  action :create
end

file '/etc/init.d/heka' do
  action :delete
end

service 'heka' do
  action %i[stop disable]
  subscribes :stop, 'package[heka]', :immediately
end

service 'hekad' do
  provider Chef::Provider::Service::Upstart if Heka::Init.upstart?
  action %i[enable start]
  subscribes :restart, 'package[heka]', :delayed
  subscribes :restart, 'homebrew_cask[heka]', :delayed
end
