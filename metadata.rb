name             'hekad'
maintainer       'Nathan Williams'
maintainer_email 'nath.e.will@gmail.com'
license          'apache2'
description      'Installs/Configures heka'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.1.0'

depends          'systemd'
depends          'homebrew'

%w( mac_os_x ubuntu fedora redhat centos scientific ).each do |p|
  supports p
end

gem 'toml-rb' if respond_to?(:gem)
source_url 'https://github.com/nathwill/chef-hekad' if respond_to?(:source_url)
issues_url 'https://github.com/nathwill/chef-hekad/issues' if respond_to?(:issues_url)
