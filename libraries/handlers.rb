#
# Cookbook Name:: hekad
# Library:: Heka::Handlers
#
# Copyright 2016 Nathan Williams
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

module Hekad
  class Handlers
    def conditionally_reload(run_context)
      updated = run_context.resource_collection.detect do |r|
        r.is_a?(HekaConfig::Base) && r.updated_by_last_action?
      end

      # Restart service if any of our configurations changed
      run_context.resource_collection
                 .resources(service: 'hekad')
                 .run_action(:restart) if updated
    end
  end
end
