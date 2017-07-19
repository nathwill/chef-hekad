require 'toml'
require 'chefspec'
require 'chefspec/berkshelf'

# Require all our libraries
Dir.glob('libraries/*.rb').shuffle.each { |f| require File.expand_path(f) }

CENTOS6_VERSION = '6.9'
CENTOS7_VERSION = '7.3.1611'
CENTOS_VERSIONS = [CENTOS6_VERSION, CENTOS7_VERSION]
UBUNTU_VERSIONS = ['14.04', '16.04']
MAC_OS_X_VERSIONS = ['10.10', '10.11', '10.12']
