#
# Cookbook Name:: hekad
# Recipe:: default
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

%w( install configure ).each do |r|
  include_recipe "#{cookbook_name}::#{r}"
end

# install systemd service unit; if your platform isn't systemd
# based, chances are it soon will be. if it isn't yet, chances
# are you're better suited than I am to set up the init system
cookbook_file '/etc/systemd/system/hekad.service' do
  source 'hekad.service'
end

include_recipe "#{cookbook_name}::service"
