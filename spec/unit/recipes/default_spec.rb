#
# Cookbook Name:: hekad
# Spec:: default
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

describe 'hekad::default' do
  CENTOS_VERSIONS.each do |v|
    context "default centos #{v}" do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'centos', version: v)
          .converge(described_recipe)
      end

      it 'installs/configures package and service' do
        %w( install configure service reload ).each do |r|
          expect(chef_run).to include_recipe "hekad::#{r}"
        end
      end

      it 'converges successfully' do
        chef_run # This should not raise an error
      end
    end
  end
end
