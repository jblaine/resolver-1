#
# Cookbook Name:: resolver
# Recipe:: from_server_role
#
# Copyright 2009, Opscode, Inc.
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

nameservers =
  search(:node, "role:#{node['resolver']['server_role']} AND chef_environment:#{node.chef_environment}").
    map {|node| node['ipaddress'] } +
  node['resolver']['nameservers']

template "/etc/resolv.conf" do
  source "resolv.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    'search' => node['resolver']['search'],
    'nameservers' => nameservers,
    'options' => node['resolver']['options']
  )
end

