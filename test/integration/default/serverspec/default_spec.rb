require 'spec_helper'

describe 'ruby-deployment-support::default' do

  describe package('epel-release') do
    it {should be_installed }
  end

  describe package('pygpgme') do
    it {should be_installed }
  end

  describe package('curl') do
    it {should be_installed }
  end

  describe file('/opt/rubyapp/test/migrated.txt') do
      it { should exist }
    end

  describe user("rubyapp") do
    it { should exist }
    it { should have_home_directory "/opt/rubyapp"}
    it { should have_login_shell '/bin/bash' }
  end

  describe file("/opt/rubyapp") do
    it { should exist }
    it { should be_directory }
  end

end
