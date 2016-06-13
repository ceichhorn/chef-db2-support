#
# Cookbook Name:: db2-support
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install base tools & daemons
include_recipe 'gdp-base-linux'
include_recipe 'yum-gd'

# packages that are a pre-req for db2
package 'epel-release' do
  action :install
end
package 'pygpgme' do
  action :install
end
package 'curl' do
  action :install
end

package 'unixODBC' do
  action :install
end

package 'db2-install' do
  package_name node['ruby-support']['package-name']
  action :install
end

# Create the app directories
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
# add the DB2 template
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/odbc.ini" do
  source 'odbc_ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# add the Mysql template
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/mysql.cnf" do
  source 'mysql_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

