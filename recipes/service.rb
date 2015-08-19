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
systemd_service 'hekad' do
  wanted_by 'multi-user.target'
  aliases %w( heka.service )
  service do
    user 'heka'
    group 'heka'
    exec_start '/usr/bin/hekad -config=/etc/heka'
    restart 'on-failure'
  end
  only_if { systemd? }
end

# CentOS 6
cookbook_file '/etc/init/hekad.conf' do
  source 'hekad.conf'
  only_if { upstart? }
  notifies :restart, 'service[hekad]', :delayed
end

# Ubuntu <= 15.04
cookbook_file '/etc/init.d/hekad' do
  source 'hekad.sysv'
  mode '0755'
  not_if { systemd? || upstart? }
  notifies :restart, 'service[hekad]', :delayed
end

service 'hekad' do
  provider Chef::Provider::Service::Upstart if upstart?
  action [:enable, :start]
end
