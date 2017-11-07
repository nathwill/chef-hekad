#
# Cookbook Name:: hekad
# Recipe:: install
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

# Setup
if platform?('mac_os_x')
  include_recipe 'homebrew'
  include_recipe 'homebrew::cask'
end

# Download
heka = node['heka']

pkg_file_path = ::File.join(
  Chef::Config['file_cache_path'] || '/tmp',
  ::File.basename(heka['package_url'])
)

remote_file 'heka_release_pkg' do
  path pkg_file_path
  source heka['package_url']
  checksum heka['checksum']
  notifies :install, 'package[heka]', :immediately
  not_if { platform?('mac_os_x') }
end

# Install
package 'heka' do
  source pkg_file_path
  provider Chef::Provider::Package::Dpkg if platform_family?('debian')
  not_if { platform?('mac_os_x') }
  action :nothing
end

homebrew_cask 'heka' do
  only_if { platform?('mac_os_x') }
end
