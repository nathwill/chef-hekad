#
# Cookbook Name:: hekad
# Recipe:: reload
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

# Adds a handler that restarts the service if any heka_config
# resources have changed; useful for those who want to remove
# the need to notify heka service from heka_config resources.

require 'chef/event_dispatch/dsl'

Chef.event_handler do
  on :converge_complete do
    Hekad::Handlers.new.conditionally_reload(Chef.run_context)
  end
end
