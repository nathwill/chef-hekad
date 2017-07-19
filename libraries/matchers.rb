# Matchers for ChefSpec
if defined?(ChefSpec)
  %w[
    heka_config
    heka_global
    heka_input
    heka_decoder
    heka_filter
    heka_encoder
    heka_output
  ].map(&:to_sym).each { |r| ChefSpec.define_matcher(r) }

  def create_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :create, check)
  end

  def delete_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :delete, check)
  end

  def create_heka_global(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_global, :create, check)
  end

  def delete_heka_global(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_global, :delete, check)
  end

  def create_heka_input(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_input, :create, check)
  end

  def delete_heka_input(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_input, :delete, check)
  end

  def create_heka_decoder(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_decoder, :create, check)
  end

  def delete_heka_decoder(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_decoder, :delete, check)
  end

  def create_heka_filter(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_filter, :create, check)
  end

  def delete_heka_filter(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_filter, :delete, check)
  end

  def create_heka_encoder(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_encoder, :create, check)
  end

  def delete_heka_encoder(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_encoder, :delete, check)
  end

  def create_heka_output(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_output, :create, check)
  end

  def delete_heka_output(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_output, :delete, check)
  end
end
