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

svc_provider = Chef::Platform.find_provider_for_node(node, :service)

cookbook_file '/etc/init/hekad.conf' do
  source 'hekad.conf'
  not_if do
    svc_provider == Chef::Provider::Service::Systemd
  end
end

cookbook_file '/etc/systemd/system/hekad.service' do
  source 'hekad.service'
  only_if do
    svc_provider == Chef::Provider::Service::Systemd
  end
end

service 'hekad' do
  action [:enable, :start]
end
