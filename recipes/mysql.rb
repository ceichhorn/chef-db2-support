#
# Cookbook Name:: ruby-deployment-support
# Recipe:: deploy
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ruby-support::default'

# calls databag which contains database credentials
credential = data_bag_item(node['ruby-support']['databag']['name'], node['ruby-support']['databag']['item'])

# create the mySQL database.yml file
template "#{node['ruby-deployment']['homedir']}/#{node['ruby-deployment']['application']['name']}/config/database.yml" do
  source 'mysql_config.erb'
  owner node['ruby-support']['user']
  group 'root'
  mode '0755'
  variables(
    :password => credential['devdbpass']
  )
  sensitive true
end
