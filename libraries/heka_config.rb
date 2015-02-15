#
# Cookbook Name: hekad
# Resource:: config
#

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

    def cookbook(arg = nil)
      set_or_return(
        :cookbook, arg,
        :kind_of => String
      )
    end

    def path(arg = nil)
      set_or_return(
        :path, arg,
        :kind_of => String,
        :default => ::File.join('etc', 'heka', "#{@name}.toml")
      )
    end

    def source(arg = nil)
      set_or_return(
        :source, arg,
        :kind_of => [String, Array],
        :default => ::File.join('heka', "#{@name}.toml.erb")
      )
    end

    def variables(arg = nil)
      set_or_return(
        :variables, arg,
        :kind_of => Hash,
        :default => {}
      )
    end
  end
end

#
# Cookbook Name: hekad
# Provider:: config
#

class Chef::Provider
  class HekaConfig < Chef::Provider
    def initialize(*args)
      super
      @cfg = Chef::Resource::Template.new(
        "heka_config_#{new_resource.name}",
        run_context
      )
    end

    # rubocop: disable AbcSize
    def load_current_resource
      @current_resource ||= Chef::Resource::HekaConfig.new(new_resource.name)
      @current_resource.cookbook(
        new_resource.cookbook || new_resource.cookbook_name
      )
      @current_resource.path new_resource.path
      @current_resource.source new_resource.source
      @current_resource.variables new_resource.variables
      @current_resource
    end
    # rubocop: enable AbcSize

    def action_create
      new_resource.updated_by_last_action(edit_cfg(:create))
    end

    def action_delete
      new_resource.updated_by_last_action(edit_cfg(:delete))
    end

    private

    def edit_cfg(exec_action)
      @cfg.cookbook @current_resource.cookbook
      @cfg.path @current_resource.path
      @cfg.source @current_resource.source
      @cfg.variables @current_resource.variables
      @cfg.run_action exec_action
      @cfg.updated_by_last_action?
    end
  end
end
