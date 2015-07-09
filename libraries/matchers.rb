# Matchers for ChefSpec 3
if defined?(ChefSpec)
  def create_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :create, check)
  end

  def delete_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :delete, check)
  end
end
