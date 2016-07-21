#
# Cookbook Name:: ruby-deployment-support
# Recipe:: s3-config-fetcher
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

include_recipe 's3cmd'

config_fetcher_script = "#{node['ruby-deployment']['home']}/#{node['ruby-deployment']['application']['name']}-s3-config-fetcher.sh"
config_fetcher_log_redirect = ">> /var/log/rubyapp/#{node['ruby-deployment']['application']['name']}-cron-config.log 2>&1"
config_fetcher_command = "#{config_fetcher_script} #{config_fetcher_log_redirect}"
config_fetcher_reloading_command = "#{config_fetcher_script} reload #{config_fetcher_log_redirect}"

execute 'copy-s3cfg' do
  command "cp /root/.s3cfg #{node['ruby-deployment']['home']}"
  user 'root'
end

# Setup Config
template config_fetcher_script do
  source 's3-config-fetcher.sh.erb'
  mode 0755
  owner node['ruby-deployment-support']['s3-fetcher']['user']
end

cron 's3-config-fetcher' do
  minute '*/10'
  command config_fetcher_reloading_command
  user node['ruby-deployment-support']['s3-fetcher']['user']
end

execute 's3-config-command' do
  command "su #{node['ruby-deployment-support']['s3-fetcher']['user']} -l -c '#{config_fetcher_command}'"
  user 'root'
end
