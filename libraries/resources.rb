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

require_relative 'helpers'

class Chef::Resource
  class HekaConfig < Chef::Resource::LWRPBase
    resource_name :heka_config
    provides :heka_config

    actions :create, :delete
    default_action :create

    attribute :type, kind_of: String
    attribute :config, kind_of: Hash, default: {}
    attribute :path, kind_of: String,
                     default: lazy { node['heka']['config_dir'] }

    def self.option_attributes(options = {})
      options.each_pair { |name, opts| attribute name, opts }
    end

    def to_toml
      TOML.dump(name => config)
    end
  end

  class HekaGlobalConfig < HekaConfig
    resource_name :heka_global_config
    provides :heka_global_config

    # there can be only one
    def name
      'hekad'
    end

    option_attributes Heka::Global::OPTIONS
  end

  class HekaInputConfig < HekaConfig
    resource_name :heka_input_config
    provides :heka_input_config

    attribute :use_tls, kind_of: [TrueClass, FalseClass]

    option_attributes Heka::Input::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::TLS::OPTIONS
  end

  class HekaSplitterConfig < HekaConfig
    resource_name :heka_splitter_config
    provides :heka_splitter_config

    option_attributes Heka::Splitter::OPTIONS
  end

  class HekaDecoderConfig < HekaConfig
    resource_name :heka_decoder_config
    provides :heka_decoder_config

    option_attributes Heka::Decoder::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
  end

  class HekaFilterConfig < HekaConfig
    resource_name :heka_filter_config
    provides :heka_filter_config

    option_attributes Heka::Filter::OPTIONS
    option_attributes Heka::Buffering::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
  end

  class HekaEncoderConfig < HekaConfig
    resource_name :heka_encoder_config
    provides :heka_encoder_config

    option_attributes Heka::Encoder::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
  end

  class HekaOutputConfig < HekaConfig
    resource_name :heka_output_config
    provides :heka_output_config

    attribute :use_tls, kind_of: [TrueClass, FalseClass]

    option_attributes Heka::Output::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::Buffering::OPTIONS
    option_attributes Heka::TLS::OPTIONS
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
          content r.to_toml
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
