#
# Cookbook Name:: hekad
# Recipe:: systemd
#
# Copyright 2015 Nathan Williams <nath.e.will@gmail.com>
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

cookbook_file '/usr/share/heka/lua_decoders/systemd_journal.lua' do
  source 'systemd_journal.lua'
end

heka_config 'systemd_journal_input' do
  config({
    "SystemdJournalInput" => {
                 "type" => "ProcessInput",
      "ticker_interval" => 0,
              "timeout" => 0,
              "decoder" => "SystemdJournalDecoder",
              "command" => {
        "0" => {
           "bin" => "/usr/bin/journalctl",
          "args" => ["-b", "-l", "-o", "json", "-f"]
        }
      }
    }
  })
  notifies :restart, 'service[hekad]', :delayed
end

heka_config 'systemd_journal_decoder' do
  config({
    "SystemdJournalDecoder" => {
          "type" => "SandboxDecoder",
      "filename" => "lua_decoders/systemd_journal.lua",
        "config" => {
                "type" => "systemd_journal",
        "payload_keep" => false
      }
    }
  })
  notifies :restart, 'service[hekad]', :delayed
end
