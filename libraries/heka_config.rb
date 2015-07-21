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

class Chef::Resource
  class HekaConfig < Chef::Resource
    identity_attr :name

    def initialize(name, run_context = nil)
      super
      @name = name
      @resource_name = :heka_config
      @provider = Chef::Provider::HekaConfig
      @allowed_actions = [:create, :delete]
      @action = :create
    end

    def path(arg = nil)
      set_or_return(
        :path, arg,
        :kind_of => String,
        :default => "/etc/heka/#{@name}.toml"
      )
    end

    def config(arg = nil)
      set_or_return(
        :config, arg,
        :kind_of => Hash,
        :default => {}
      )
    end
  end
end

class Chef::Provider
  class HekaConfig < Chef::Provider
    def initialize(*args)
      super
      Chef::Resource::ChefGem.new('toml-rb', run_context).run_action(:install)
      @cfg = Chef::Resource::File.new(
        "heka_config_#{new_resource.name}",
        run_context
      )
    end

    def load_current_resource
      @current_resource ||= Chef::Resource::HekaConfig.new(
        new_resource.name,
        run_context
      )
      @current_resource.path new_resource.path
      @current_resource.config new_resource.config
      @current_resource
    end

    def action_create
      new_resource.updated_by_last_action(edit_cfg(:create))
    end

    def action_delete
      new_resource.updated_by_last_action(edit_cfg(:delete))
    end

    private

    def edit_cfg(exec_action)
      require 'toml'
      @cfg.path @current_resource.path
      @cfg.content TOML.dump(@current_resource.name => @current_resource.config)
      @cfg.run_action exec_action
      @cfg.updated_by_last_action?
    end
  end
end
