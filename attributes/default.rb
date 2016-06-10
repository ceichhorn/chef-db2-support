default['yum-gd']['repos'] = %w(centos centos-updates datadog epel gdcustom opsmatic scalr CentOS-Base CentOS-Debuginfo CentOS-fasttrack CentOS-Media yum-ibm)
default['yum']['gdcustom']['enabled'] = true
default['db2-support']['package-name'] = 'ibm-iaccess'
default['db2-support']['server']['name'] = 'marvel'
default['db2-support']['server']['address'] = 'marvel.ent.gci'
default['ruby-deployment']['homedir'] = '/opt/rubyapp'
default['ruby-deployment']['application']['name'] = 'test'
