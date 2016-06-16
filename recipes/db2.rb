#
# Cookbook Name:: ruby-deployment-support
# Recipe:: deploy
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ruby-support::default'

# required package for db2 odbc connection
package 'unixODBC' do
  action :install
end

# install db2 rpm
package 'db2-install' do
  package_name node['ruby-support']['package-name']
  action :install
end

# create the db2 odbc.ini file
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/odbc.ini" do
  source 'odbc_ini.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
