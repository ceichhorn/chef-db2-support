#
# Cookbook Name:: ruby-deployment-support
# Recipe:: default
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

# required package for db2 odbc connection
package 'unixODBC' do
  action :install
  only_if { node['ruby-deployment-support']['db2']['install'] }
end

# install db2 rpm
package 'db2-install' do
  package_name node['ruby-deployment-support']['package-name']
  action :install
  only_if { node['ruby-deployment-support']['db2']['install'] }
end

# create the db2 odbc.ini file
template '/etc/odbc.ini' do
  source 'odbc_ini.erb'
  owner 'root'
  group 'root'
  mode '0755'
  only_if { node['ruby-deployment-support']['db2']['install'] }
end

# run your migrate command
bash 'migrate' do
  cwd "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}"
  code node['ruby-deployment']['application']['migration_command']
  user node['ruby-deployment']['user']
  notifies :create, 'file[migrated.txt]', :immediately
  only_if { node['ruby-deployment']['application']['migrate'] && ::File.exist?("#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/migrated.txt").! } # rubocop:disable Style/LineLength
end

file 'migrated.txt' do
  owner node['ruby-deployment']['user']
  mode '0644'
  path "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/migrated.txt"
  action :nothing
end
