#
# Cookbook Name:: ruby-deployment-support
# Recipe:: s3-secrets-fetcher
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

include_recipe 's3cmd'

secrets_fetcher_script = "#{node['ruby-deployment']['home']}/#{node['ruby-deployment']['application']['name']}-s3-secrets-fetcher.sh"
secrets_fetcher_log_redirect = ">> /var/log/rubyapp/#{node['ruby-deployment']['application']['name']}-cron-secrets.log 2>&1"
secrets_fetcher_command = "#{secrets_fetcher_script} #{secrets_fetcher_log_redirect}"
secrets_fetcher_reloading_command = "#{secrets_fetcher_script} reload #{secrets_fetcher_log_redirect}"

execute 'copy-s3cfg' do
  command "cp /root/.s3cfg #{node['ruby-deployment']['home']}"
  user 'root'
end

# Setup secrets
template secrets_fetcher_script do
  source 's3-secrets-fetcher.sh.erb'
  mode 0755
  owner node['ruby-deployment-support']['s3-fetcher']['user']
end

cron 's3-secrets-fetcher' do
  minute '*/10'
  command secrets_fetcher_reloading_command
  user node['ruby-deployment-support']['s3-fetcher']['user']
end

execute 's3-secrets-command' do
  command "su #{node['ruby-deployment-support']['s3-fetcher']['user']} -l -c '#{secrets_fetcher_command}'"
  user 'root'
end
