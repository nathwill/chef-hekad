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
  context 'When all attributes are default, on Ubuntu' do
    UBUNTU_VERSIONS.each do |v|
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: v)
        .converge(described_recipe)
      end

      before do
        allow(Heka::Init).to receive(:systemd?).and_return(false)
        allow(Heka::Init).to receive(:upstart?).and_return(true)
      end

      it 'skips the launchd plist' do
        expect(chef_run).to_not create_template '/Library/LaunchDaemons/hekad.plist'
      end

      it 'converges successfully' do
        chef_run # This should not raise an error
      end
    end
  end

  MAC_OS_X_VERSIONS.each do |v|
    context "When all attributes are default, on Mac OS #{v}" do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: v)
        .converge(described_recipe)
      end

      it 'creates the launchd plist' do
        expect(chef_run).to create_template '/Library/LaunchDaemons/hekad.plist'
      end

      it 'converges successfully' do
        chef_run # This should not raise an error
      end
    end
  end

  context 'When all attributes are default, on CentOS 7' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: CENTOS7_VERSION)
      .converge(described_recipe)
    end

    before do
      allow(Heka::Init).to receive(:systemd?).and_return(true)
      allow(Heka::Init).to receive(:upstart?).and_return(false)
    end

    it 'skips the launchd plist' do
      expect(chef_run).to_not create_template '/Library/LaunchDaemons/hekad.plist'
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: CENTOS6_VERSION)
    .converge(described_recipe)
  end

  before do
    allow(Heka::Init).to receive(:systemd?).and_return(false)
    allow(Heka::Init).to receive(:upstart?).and_return(false)
  end

  it 'creates the heka user' do
    expect(chef_run).to create_user('heka').with(
      shell: '/bin/false',
      system: true,
      gid: 'heka'
    )
  end

  it 'creates the heka group' do
    expect(chef_run).to create_group('heka').with(system: true)
  end

  it 'creates the heka base_dir' do
    expect(chef_run).to create_directory('/var/cache/hekad').with(
      owner: 'heka',
      group: 'heka',
      recursive: true,
    )
  end

  it 'manages the heka service' do
    expect(chef_run).to delete_file '/etc/init.d/heka'
    expect(chef_run).to disable_service 'heka'
    expect(chef_run).to stop_service 'heka'
  end

  it 'manages the hekad service' do
    expect(chef_run).to disable_service 'heka'
    expect(chef_run).to stop_service 'heka'
    expect(chef_run).to enable_service 'hekad'
    expect(chef_run).to start_service 'hekad'
  end

  it 'converges successfully' do
    chef_run
  end
end
