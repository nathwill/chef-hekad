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
  # rubocop: disable LineLength
  heka['package_url'] = value_for_platform(
    'mac_os_x' => {
      'default' => 'https://github.com/mozilla-services/heka/releases/download/v0.9.2/heka-0_9_2-darwin-amd64.dmg'
    },
    'default' => value_for_platform_family(
      'debian' => 'https://github.com/mozilla-services/heka/releases/download/v0.9.2/heka_0.9.2_amd64.deb',
      'default' => 'https://github.com/mozilla-services/heka/releases/download/v0.9.2/heka-0_9_2-linux-amd64.rpm'
    )
  )

  heka['checksum'] = value_for_platform(
    'mac_os_x' => {
      'default' => '5fef4af06b97bf926fbec7ecb5c7983eed80601d56b2bedac02dad6b8677a094'
    },
    'default' => value_for_platform_family(
      'debian' => 'e38b223f46aed80276635fa271d9b3a03fa8577f9aeffddea612ad150c614a15',
      'default' => 'ddfab13c65e2c5716539f0a2da99bd5e5d1debc793775cf226718e9c5f85bccf'
    )
  )
  # rubocop: enable LineLength

  heka['config'] = {
    'maxprocs' => 2
  }
end
