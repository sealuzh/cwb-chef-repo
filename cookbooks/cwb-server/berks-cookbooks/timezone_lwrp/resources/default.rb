# vim: ts=2 sts=2 sw=2 et sta
#
# Cookbook Name:: timezone
# Resource:: default
#
# Author:: Kirill Kouznetsov <agon.smith@gmail.com>
#
# Copyright 2018, Kirill Kouznetsov.
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

resource_name :timezone

property :timezone, String, name_property: true

action :set do
  package 'tzdata' do
    package_name platform_family?('suse') ? 'timezone' : 'tzdata'
  end

  if node['init_package'] == 'systemd'
    # Modern Fedora, CentOS, RHEL, Ubuntu & Debian
    cmd_set_tz = '/usr/bin/timedatectl'
    cmd_set_tz += ' '
    cmd_set_tz += '--no-ask-password'
    cmd_set_tz += ' '
    cmd_set_tz += "set-timezone #{new_resource.timezone}"

    cmd_check_if_set = '/usr/bin/timedatectl status'
    cmd_check_if_set += " | /usr/bin/awk '/Time.*zone/{print}'"
    cmd_check_if_set += " | grep -q #{new_resource.timezone}"

    execute cmd_set_tz do
      action :run
      not_if cmd_check_if_set
    end
  elsif platform_family?('rhel', 'amazon')
    # Old version of RHEL & CentOS
    file '/etc/sysconfig/clock' do
      owner 'root'
      group 'root'
      mode '0644'
      action :create
      content %(ZONE="#{new_resource.timezone}"\nUTC="true"\n)
    end

    execute 'tzdata-update' do
      command '/usr/sbin/tzdata-update'
      action :nothing
      only_if { ::File.executable?('/usr/sbin/tzdata-update') }
      subscribes :run, 'file[/etc/sysconfig/clock]', :immediately
    end

    link '/etc/localtime' do
      to "/usr/share/zoneinfo/#{new_resource.timezone}"
      not_if { ::File.executable?('/usr/sbin/tzdata-update') }
    end
  elsif platform_family?('debian')
    file '/etc/timezone' do
      action :create
      content "#{new_resource.timezone}\n"
    end

    bash 'dpkg-reconfigure tzdata' do
      user 'root'
      code '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata'
      action :nothing
      subscribes :run, 'file[/etc/timezone]', :immediately
    end
  end
end
