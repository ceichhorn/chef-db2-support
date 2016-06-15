#
# Cookbook Name:: db2-support
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install base tools & daemons
include_recipe 'gdp-base-linux'

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

credential = data_bag_item(node['ruby-support']['databag']['name'], node['ruby-support']['databag']['item'])

# add the Mysql template
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/database.yml" do
  source 'mysql_config.erb'
  owner node['ruby-support']['user']
  group 'root'
  mode '0644'
  variables(
    :password => credential['devdbpass']
  )
  sensitive true
end

# add the secrets template
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/secrets.yml" do
  source 'secrets.erb'
  owner node['ruby-support']['user']
  group 'root'
  mode '0644'
end
