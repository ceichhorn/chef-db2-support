require 'spec_helper'
require 'fauxhai'

describe 'ruby-deployment-support::s3_secrets_fetcher' do
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

    it 'executes a copy command for .s3cfg' do
      expect(chef_run).to run_execute('cp /root/.s3cfg /opt/rubyapp').with_user('root')
    end
    it 'creates s3-secrets-fetcher' do
      expect(chef_run).to create_template('/opt/rubyapp/test-s3-secrets-fetcher.sh').with(
        source: 's3-secrets-fetcher.sh.erb',
        mode: 0755,
        owner: 'rubyapp'
      )
    end
    it 'creates s3-secrets-fetcher with contents' do
      expect(chef_run).to render_file('/opt/rubyapp/test-s3-secrets-fetcher.sh').with_content('TEMP_CONFIG_DIR="/opt/rubyapp/test-configs"')
      expect(chef_run).to render_file('/opt/rubyapp/test-s3-secrets-fetcher.sh').with_content('TARGET_CONFIG_FILE="/opt/rubyapp/test/config/secrets.yml"')
      expect(chef_run).to render_file('/opt/rubyapp/test-s3-secrets-fetcher.sh').with_content('s3cmd -c /opt/rubyapp/.s3cfg get s3://gdp-commerce-configs/test-$ENVIRONMENT-secrets.yml $TEMP_CONFIG_FILE')
      expect(chef_run).to render_file('/opt/rubyapp/test-s3-secrets-fetcher.sh').with_content('cp -v $TEMP_CONFIG_FILE $TARGET_CONFIG_FILE')
      expect(chef_run).to render_file('/opt/rubyapp/test-s3-secrets-fetcher.sh').with_content('service nginx restart')
    end
    it 'creates a cron entry' do
      expect(chef_run).to create_cron('s3-secrets-fetcher').with(
        minute: '*/10',
        command: "/opt/rubyapp/test-s3-secrets-fetcher.sh reload >> /var/log/rubyapp/test-cron-secrets.log 2>&1",
        user: 'rubyapp'
      )
    end
    it 'executes a fetch command as user node' do
      expect(chef_run).to run_execute('su rubyapp -l -c \'/opt/rubyapp/test-s3-secrets-fetcher.sh >> /var/log/rubyapp/test-cron-secrets.log 2>&1\'').with_user('root')
end

  end
end
