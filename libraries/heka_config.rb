#
# Cookbook Name:: hekad
# Resource:: heka_config
# Provider:: heka_config
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

require 'chef/resource/lwrp_base'
require 'chef/provider/lwrp_base'
require 'chef/mixin/params_validate'

class Chef::Resource
  class HekaConfig < Chef::Resource::LWRPBase
    resource_name :heka_config
    provides :heka_config

    actions :create, :delete
    default_action :create

    attribute :config, kind_of: Hash, default: {}
    attribute :path, kind_of: String,
                     default: lazy { node['heka']['config_dir'] }
  end
end

class Chef::Provider
  class HekaConfig < Chef::Provider::LWRPBase
    def initialize(*args)
      super
      Chef::Resource::ChefGem.new('toml-rb', run_context).run_action(:install)
      require 'toml'
    end

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :heka_config

    %i( create delete ).each do |a|
      action a do
        r = new_resource

        f = file ::File.join(r.path, "#{r.name}.toml") do
          content TOML.dump(r.name => r.config)
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
