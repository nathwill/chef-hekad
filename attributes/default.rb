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
  heka['config_dir'] = '/etc/heka.d'

  heka['config'] = {
    'maxprocs' => 2
  }

  # rubocop: disable LineLength
  heka['package_url'] = value_for_platform(
    'mac_os_x' => {
      'default' => 'https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka-0_10_0-darwin-amd64.dmg'
    },
    'default' => value_for_platform_family(
      'debian' => 'https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka_0.10.0_amd64.deb',
      'default' => 'https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka-0_10_0-linux-amd64.rpm'
    )
  )

  heka['checksum'] = value_for_platform(
    'mac_os_x' => {
      'default' => '9416e6ce0e3fe56926df86607d8e0c286cd0e9773d9038c80887558ae6f41c55'
    },
    'default' => value_for_platform_family(
      'debian' => 'bb56953955a696b8111b3704bab09d1381a955b49b9378d20a63e665f253ec4a',
      'default' => '383a5d39c5ed62ba2ec95eb5e87555a2107b68bbab9adab9d5195a8a597d803a'
    )
  )
  # rubocop: enable LineLength
end
