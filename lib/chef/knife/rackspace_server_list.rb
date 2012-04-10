#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Matt Ray (<matt@opscode.com>)
# Copyright:: Copyright (c) 2009-2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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
#

require 'chef/knife/rackspace_base'

class Chef
  class Knife
    class RackspaceServerList < Knife

      include Knife::RackspaceBase

      banner "knife rackspace server list (options)"

      def run
        $stdout.sync = true

        server_list = [
          ui.color('Name', :bold),
          ui.color('Public IPv4', :bold),
          ui.color('Public IPv6', :bold),
          ui.color('Private IPv4', :bold),
          ui.color('Flavor', :bold),
          ui.color('Image', :bold),
          ui.color('State', :bold)
        ]
        connection.servers.all.each do |server|
          server_list << server.name
          server_list << server.ip_address('public',4).to_s
          server_list << server.ip_address('public',6).to_s
          server_list << server.ip_address('private',4).to_s
          server_list << server.flavor['id'].to_s
          server_list << server.image['id'].to_s
          server_list << begin
            case server.state.downcase
            when 'deleted','error','suspended','unknown'
              ui.color(server.state.downcase, :red)
            when 'build','hard_reboot','password','reboot','rebuild','resize','verify_resize'
              ui.color(server.state.downcase, :yellow)
            else
              ui.color(server.state.downcase, :green)
            end
          end
        end
        puts ui.list(server_list, :columns_across, 7)

      end
    end
  end
end
