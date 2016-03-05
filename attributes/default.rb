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
  heka['user'] = 'heka'

  heka['config_dir'] = '/etc/heka/conf.d'

  heka['config'].tap do |c|
    c['maxprocs'] = 2
    c['base_dir'] = '/var/cache/hekad'
  end

  # These do not apply to mac_os_x
  heka['package_url'] = value_for_platform(
    'default' => value_for_platform_family(
      'debian' => 'https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka_0.10.0_amd64.deb',
      'default' => 'https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka-0_10_0-linux-amd64.rpm'
    )
  )

  # rubocop: disable LineLength
  heka['checksum'] = value_for_platform(
    'default' => value_for_platform_family(
      'debian' => 'bb56953955a696b8111b3704bab09d1381a955b49b9378d20a63e665f253ec4a',
      'default' => '383a5d39c5ed62ba2ec95eb5e87555a2107b68bbab9adab9d5195a8a597d803a'
    )
  )
  # rubocop: enable LineLength
end
