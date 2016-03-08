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

directory node['heka']['config_dir'] do
  recursive true
end

config = node['heka']['config']

# Install global configuration
heka_global 'hekad' do
  maxprocs config['maxprocs']
  base_dir config['base_dir']
end
