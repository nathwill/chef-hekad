#
# Cookbook Name:: hekad
# Resource:: Chef::Resource::Heka*Config
# Provider:: Chef::Provider::HekaConfig}
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

class HekaConfig
  class Base < Chef::Resource::LWRPBase
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
      conf = {}.merge config
      conf[:type] ||= type || config['type']
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
  end

  class Global < Base
    resource_name :heka_global
    provides :heka_global

    option_attributes Heka::Global::OPTIONS

    def to_toml
      conf = {}.merge config
      conf[:type] = type
      Heka::Global::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(hekad: conf).body
    end
  end

  class Input < Base
    resource_name :heka_input
    provides :heka_input

    attribute :use_tls, kind_of: [TrueClass, FalseClass]

    option_attributes Heka::Input::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::TLS::OPTIONS
    option_attributes Heka::Restart::OPTIONS

    def tls_config
      yield
    end

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def to_toml
      conf = {}.merge config
      conf[:type] = type
      conf[:use_tls] = use_tls
      Heka::Input::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      Heka::Restart::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      if type =~ /^Sandbox(Input|Decoder|Filter|Encoder|Output)/
        Heka::Sandbox::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
        conf[:config] = conf.delete(:sandbox_config)
      end
      if conf[:use_tls]
        conf[:tls] = {}
        Heka::TLS::OPTIONS.each_pair do |k, _|
          conf[:tls][k] = send(k) unless send(k).nil?
        end
      end
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
  end

  class Splitter < Base
    resource_name :heka_splitter
    provides :heka_splitter

    option_attributes Heka::Splitter::OPTIONS
    option_attributes Heka::Restart::OPTIONS

    def to_toml
      conf = {}.merge config
      conf[:type] = type
      Heka::Restart::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      Heka::Splitter::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
  end

  class Decoder < Base
    resource_name :heka_decoder
    provides :heka_decoder

    option_attributes Heka::Decoder::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::Restart::OPTIONS

    # rubocop: disable AbcSize
    def to_toml
      conf = {}.merge config
      conf[:type] = type
      Heka::Decoder::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      Heka::Restart::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      if type =~ /^Sandbox(Input|Decoder|Filter|Encoder|Output)/
        Heka::Sandbox::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
        conf[:config] = conf.delete(:sandbox_config)
      end
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
    # rubocop: enable AbcSize
  end

  class Filter < Base
    resource_name :heka_filter
    provides :heka_filter

    option_attributes Heka::Filter::OPTIONS
    option_attributes Heka::Buffering::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::Restart::OPTIONS

    def buffering_config
      yield
    end

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def to_toml
      conf = {}.merge config
      conf[:type] = type
      Heka::Filter::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      Heka::Restart::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      if conf[:use_buffering]
        conf[:buffering] = {}
        Heka::Buffering::OPTIONS.each_pair do |k, _|
          conf[:buffering][k] = send(k) unless send(k).nil?
        end
      end
      if type =~ /^Sandbox(Input|Decoder|Filter|Encoder|Output)/
        Heka::Sandbox::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
        conf[:config] = conf.delete(:sandbox_config)
      end
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
  end

  class Encoder < Base
    resource_name :heka_encoder
    provides :heka_encoder

    option_attributes Heka::Encoder::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::Restart::OPTIONS

    # rubocop: disable AbcSize
    def to_toml
      conf = {}.merge config
      conf[:type] = type
      Heka::Restart::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      Heka::Encoder::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      if type =~ /^Sandbox(Input|Decoder|Filter|Encoder|Output)/
        Heka::Sandbox::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
        conf[:config] = conf.delete(:sandbox_config)
      end
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
    # rubocop: enable AbcSize
  end

  class Output < Base
    resource_name :heka_output
    provides :heka_output

    attribute :use_tls, kind_of: [TrueClass, FalseClass]

    option_attributes Heka::Output::OPTIONS
    option_attributes Heka::Sandbox::OPTIONS
    option_attributes Heka::Buffering::OPTIONS
    option_attributes Heka::TLS::OPTIONS
    option_attributes Heka::Restart::OPTIONS

    def tls_config
      yield
    end

    def buffering_config
      yield
    end

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def to_toml
      conf = {}.merge config
      conf[:type] = type
      conf[:use_tls] = use_tls
      Heka::Restart::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      Heka::Output::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
      if type =~ /^Sandbox(Input|Decoder|Filter|Encoder|Output)/
        Heka::Sandbox::OPTIONS.each_pair { |k, _| conf[k] = send(k) }
        conf[:config] = conf.delete(:sandbox_config)
      end
      if conf[:use_buffering]
        conf[:buffering] = {}
        Heka::Buffering::OPTIONS.each_pair do |k, _|
          conf[:buffering][k] = send(k) unless send(k).nil?
        end
      end
      if conf[:use_tls]
        conf[:tls] = {}
        Heka::TLS::OPTIONS.each_pair do |k, _|
          conf[:tls][k] = send(k) unless send(k).nil?
        end
      end
      conf.delete_if { |_, v| v.nil? }
      TOML::Generator.new(name => conf).body
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
  end

  class Provider < Chef::Provider::LWRPBase
    def initialize(*args)
      super
      begin
        require 'toml'
      rescue LoadError
        Chef::Resource::ChefGem.new('toml-rb', run_context).run_action(:install)
        retry
      end
    end

    use_inline_resources

    def whyrun_supported?
      true
    end

    %w[
      heka_config
      heka_global
      heka_input
      heka_splitter
      heka_decoder
      heka_filter
      heka_encoder
      heka_output
    ].map(&:to_sym).each { |r| provides r }

    %w[create delete].map(&:to_sym).each do |a|
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
