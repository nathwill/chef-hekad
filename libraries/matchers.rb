# Matchers for ChefSpec 3
if defined?(ChefSpec)
  def create_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :create, check)
  end

  def remove_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :remove, check)
  end
end
