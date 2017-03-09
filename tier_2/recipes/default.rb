#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

include_attribute "global"

# Configuring default folders under assets
%w{data jdbc-pool logs packages system-tmp tmp}.each do |dir|
  directory "#{node[:application][:assets_dir]}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

# Configuring default folders under configs
%w{.java custom-web-configs}.each do |dir|
  directory "#{node[:application][:configs_dir]}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

# Configure database
cookbook_file "/tmp/configure_mysql.sh" do
  source "mysql-config.sh"
  mode 0755
  owner "root"
end

execute "configure mysql" do
  user "root"
  command "sh /tmp/configure_mysql.sh '#{node[:application][:code]}' '#{node[:database][:username]}' '#{node[:database][:password]}' '#{node[:database][:master_user]}' '#{node[:database][:master_pass]}' '#{node[:database][:host]}' > #{node[:infra][:log_dir]}/mysql-config-${HOSTNAME}-$(date +"%m-%d-%y").log"
end
