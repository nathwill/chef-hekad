# Cookbook Name:: hekad
# Spec:: install
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

require 'spec_helper'

describe 'hekad::install' do
  CENTOS_VERSIONS.each do |v|
    context 'When all attributes are default, on an unspecified platform' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'centos', version: v)
          .converge(described_recipe)
      end

      it 'downloads the package' do
        expect(chef_run).to create_remote_file 'heka_release_pkg'
      end

      it 'converges successfully' do
        chef_run # This should not raise an error
      end
    end
  end
end
