require 'spec_helper'
require 'fauxhai'

describe 'ruby-deployment-support::default' do
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

    it 'creates rubyapp user' do
      expect(chef_run).to create_user('rubyapp')
    end

    it 'does not create the odbc.ini file' do
      expect(chef_run).to_not create_template('/etc/odbc.ini')
    end

    it 'does nothing on migrated.txt file' do
      file = chef_run.file('migrated.txt')
      expect(file).to do_nothing
    end

    it 'run migrate script' do
      expect(chef_run).to run_bash('migrate')
    end

    it 'creates migrated.txt file' do
      resource = chef_run.bash('migrate')
      expect(resource).to notify('file[migrated.txt]').to(:create).immediately
    end

    it 'creates an app config directory' do
      expect(chef_run).to create_directory('/opt/rubyapp/test/config/')
    end

    it 'does not install unixODBC' do
      expect(chef_run).to_not install_package('unixODBC')
    end

    it 'does not install db2-install' do
      expect(chef_run).to_not install_package('db2-install')
    end

    # installed packages
    package_list = ['epel-release', 'pygpgme', 'curl']

    package_list.each do |name|
      it 'installs ' + name do
        expect(chef_run).to install_package(name)
      end
    end
  end

  context 'On Centos 7.1 with odbc set to true' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.1.1503') do |node|
        Chef::Config[:client_key] = "/etc/chef/client.pem"
        node.set['ruby-deployment']['application']['name'] = 'test'
        stub_command("which sudo").and_return('/usr/bin/sudo')
        node.set['authorization']['sudo']['groups'] = ["admin", "wheel", "test"]
        node.set['ssh_keys'] = ''
        node.default['ssh_keys'] = { test: ["test"] }
        node.set['ruby-deployment-support']['db2']['install'] = true
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

    it 'creates rubyapp user' do
      expect(chef_run).to create_user('rubyapp')
    end

    it 'does not create the odbc.ini file' do
      expect(chef_run).to create_template('/etc/odbc.ini')
    end

    it 'does nothing on migrated.txt file' do
      file = chef_run.file('migrated.txt')
      expect(file).to do_nothing
    end

    it 'run migrate script' do
      expect(chef_run).to run_bash('migrate')
    end

    it 'creates migrated.txt file' do
      resource = chef_run.bash('migrate')
      expect(resource).to notify('file[migrated.txt]').to(:create).immediately
    end

    it 'creates an app config directory' do
      expect(chef_run).to create_directory('/opt/rubyapp/test/config/')
    end

    it 'does not install unixODBC' do
      expect(chef_run).to install_package('unixODBC')
    end

    it 'does not install db2-install' do
      expect(chef_run).to install_package('db2-install')
    end

    # installed packages
    package_list = ['epel-release', 'pygpgme', 'curl']

    package_list.each do |name|
      it 'installs ' + name do
        expect(chef_run).to install_package(name)
      end
    end

  end
end
