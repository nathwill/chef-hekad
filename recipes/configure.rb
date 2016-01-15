#
# Cookbook Name:: hekad
# Recipe:: configure
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

# Create our own config.d dir
directory node['heka']['config_dir']

# Remove package-installed dir, and
# shut down service if present, as this
# is likely a first-install, and the user
# creation will fail to usermod otherwise.
directory '/etc/heka' do
  recursive true
  action :delete
  not_if { node['heka']['config_dir'] == '/etc/heka' }
  notifies :restart, 'service[hekad]', :delayed
end

# Install global configuration
heka_config 'hekad' do
  config node['heka']['config']
end
