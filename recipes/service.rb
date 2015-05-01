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

cookbook_file '/etc/init/hekad.conf' do
  source 'hekad.conf'
  only_if do
    ::File.directory?('/etc/init')
  end
end

cookbook_file '/etc/systemd/system/hekad.service' do
  source 'hekad.service'
  only_if do
    ::File.directory?('/etc/systemd/system')
  end
end

if platform_family?('debian') and node['heka']['service']['upstart']
  cookbook_file '/etc/init.d/hekad' do
    source 'hekad.upstart'
    only_if do
      ::File.directory?('/etc/init.d')
    end
  end

  group 'heka' do
    action :create
  end

  user 'heka' do
    system true
    gid 'heka'
  end

  service 'hekad' do
    action [:enable, :start]
    provider Chef::Provider::Service::Upstart
  end
else
  service 'hekad' do
    action [:enable, :start]
  end
end
