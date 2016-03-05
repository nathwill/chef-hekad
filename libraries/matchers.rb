# Matchers for ChefSpec
if defined?(ChefSpec)
  %w(
    heka_config
    heka_global_config
    heka_input_config
    heka_decoder_config
    heka_filter_config
    heka_encoder_config
    heka_output_config
  ).map(&:to_sym).each { |r| ChefSpec.define_matcher(r) }

  def create_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :create, check)
  end

  def delete_heka_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_config, :delete, check)
  end

  def create_heka_global_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_global_config, :create, check)
  end

  def delete_heka_global_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_global_config, :delete, check)
  end

  def create_heka_input_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_input_config, :create, check)
  end

  def delete_heka_input_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_input_config, :delete, check)
  end

  def create_heka_decoder_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_decoder_config, :create, check) # rubocop: disable LineLength
  end

  def delete_heka_decoder_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_decoder_config, :delete, check) # rubocop: disable LineLength
  end

  def create_heka_filter_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_filter_config, :create, check)
  end

  def delete_heka_filter_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_filter_config, :delete, check)
  end

  def create_heka_encoder_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_encoder_config, :create, check) # rubocop: disable LineLength
  end

  def delete_heka_encoder_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_decoder_config, :delete, check) # rubocop: disable LineLength
  end

  def create_heka_output_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_output_config, :create, check)
  end

  def delete_heka_output_config(check)
    ChefSpec::Matchers::ResourceMatcher.new(:heka_output_config, :delete, check)
  end
end
