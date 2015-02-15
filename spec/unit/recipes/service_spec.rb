# Cookbook Name:: hekad
# Spec:: service
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

describe 'hekad::service' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'manages the hekad service' do
      expect(chef_run).to enable_service 'hekad'
      expect(chef_run).to start_service 'hekad'
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'When all attributes are default, on Ubuntu' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04')
      .converge(described_recipe)
    end

    it 'installs the upstart configuration' do
      expect(chef_run).to create_cookbook_file '/etc/init/hekad.conf'
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'When all attributes are default, on CentOS 7' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0')
      .converge(described_recipe)
    end

    it 'installs the systemd unit file for hekad' do
      expect(chef_run).to create_cookbook_file '/etc/systemd/system/hekad.service'
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
