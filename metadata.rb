name             'hekad'
maintainer       'Nathan Williams'
maintainer_email 'nath.e.will@gmail.com'
license          'apache2'
description      'Installs/Configures heka'
long_description 'Installs/Configures heka'
version          '4.0.3'
depends          'systemd'

%w( mac_os_x ubuntu fedora redhat centos scientific ).each do |p|
  supports p
end

unless defined?(Ridley::Chef::Cookbook::Metadata)
  source_url 'https://github.com/nathwill/chef-hekad' if respond_to?(:source_url)
  issues_url 'https://github.com/nathwill/chef-hekad/issues' if respond_to?(:issues_url)
end
