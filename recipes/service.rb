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

group 'heka' do
  system true
  action :create
end

user 'heka' do
  home '/var/lib/heka'
  shell '/bin/false'
  system true
  gid 'heka'
end

directory '/var/cache/hekad' do
  owner 'heka'
  group 'heka'
  recursive true
end

# Fedora, CentOS >= 7, Ubuntu >= 15.04, Debian >= 8
cookbook_file '/etc/systemd/system/hekad.service' do
  source 'hekad.service'
  only_if { ::File.directory?('/etc/systemd/system') }
  not_if { ::File.directory?('/etc/init') && !platform?('debian') }
  notifies :restart, 'service[hekad]', :delayed
end

# CentOS 6
cookbook_file '/etc/init/hekad.conf' do
  source 'hekad.conf'
  only_if { ::File.directory?('/etc/init') }
  not_if { platform?('debian') && node['platform_version'].to_f >= 8.0 }
  notifies :restart, 'service[hekad]', :delayed
end

# Ubuntu <= 15.04
cookbook_file '/etc/init.d/hekad' do
  source 'hekad.sysv'
  mode '0755'
  not_if do
    platform_family?('rhel') ||
      ::File.exist?('/etc/init')
  end
  notifies :restart, 'service[hekad]', :delayed
end

service 'hekad' do
  if ::File.exist?('/etc/init') && !platform?('debian')
    provider Chef::Provider::Service::Upstart
  end
  action [:enable, :start]
end
