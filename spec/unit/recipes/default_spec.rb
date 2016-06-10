#
# Cookbook Name:: db2-support
# Spec:: default
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

require 'spec_helper'
require 'fauxhai'

describe 'db2-support::default' do
  context 'On Centos 7.1 with defaults set' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.1.1503') do |node|
        Chef::Config[:client_key] = "/etc/chef/client.pem"
        node.set['ruby-deployment']['application']['name'] = 'test'
        stub_command("which sudo").and_return('/usr/bin/sudo')
        node.set['authorization']['sudo']['groups'] = ["admin", "wheel", "test"]
        node.set['ssh_keys'] = ''
        node.default['ssh_keys'] = { test: ["test"] }
      end.converge(described_recipe)
    end
    # included recipes
    recipe_list = ['gdp-base-linux']

    recipe_list.each do |name|
      it 'includes the recipe ' + name do
        expect(chef_run).to include_recipe(name)
      end
    end

    it 'creates a app directory' do
      expect(chef_run).to create_directory('/opt/rubyapp/test/')
    end

    it 'creates an app config directory' do
      expect(chef_run).to create_directory('/opt/rubyapp/test/config/')
    end

    it 'creates the odbc template' do
      expect(chef_run).to create_template('/opt/rubyapp/test/config/odbc.ini')
    end

    # installed packages
    package_list = ['epel-release', 'pygpgme', 'curl', 'unixODBC', 'ibm-iaccess']

    package_list.each do |name|
      it 'installs ' + name do
        expect(chef_run).to install_package(name)
      end
    end
   
 end
end
