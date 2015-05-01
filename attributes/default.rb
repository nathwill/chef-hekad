#
# Cookbook Name:: hekad
# Attributes:: default
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

default['heka'].tap do |heka|
  heka['release_url'] = %w(
    https://github.com
    mozilla-services
    heka
    releases
    download
  ).join('/')

  heka['version'] = '0.9.2'

  heka['tag'] = "v#{heka['version']}"

  heka['package'] = value_for_platform_family(
    'debian' => "heka_#{heka['version']}_amd64.deb",
    'default' => "heka-#{heka['version'].gsub('.', '_')}-linux-amd64.rpm"
  )

  heka['config'] = {
    'hekad' => {
      'maxprocs' => 2,
      'pid_file' => '/var/run/hekad.pid'
    }
  }

  # Set to true to use Upstart instead of systemd on debian
  heka['service']['upstart'] = false

end
