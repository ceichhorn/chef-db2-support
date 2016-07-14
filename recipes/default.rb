#
# Cookbook Name:: ruby-deployment-support
# Recipe:: deploy
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

# install base tools & daemons
include_recipe 'gdp-base-linux'

# pre-req packages
package 'epel-release' do
  action :install
end
package 'pygpgme' do
  action :install
end
package 'curl' do
  action :install
end

# create the application directories and user
user node['ruby-deployment']['user'] do
  action :create
  home node['ruby-deployment']['homedir']
end

directory "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/" do
  recursive true
  mode '0755'
  action :create
end

directory "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/" do
  recursive true
  mode '0755'
  action :create
end

# run your migrate command
bash 'migrate' do
  cwd "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}"
  code node['ruby-deployment']['application']['migration_command']
  user node['ruby-deployment']['user']
  notifies :create, 'file[migrated.txt]', :immediately
  only_if { node['ruby-deployment']['application']['migrate'] && ::File.exist?("#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/migrated.txt").! } # rubocop:disable Style/LineLength
end

