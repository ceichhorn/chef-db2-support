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

# create the application directories
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

# create the secrets.yml file
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/secrets.yml" do
  source 'secrets.erb'
  owner node['ruby-support']['user']
  group 'root'
  mode '0755'
end
