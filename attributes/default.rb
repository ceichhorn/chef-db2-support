default['yum']['gdcustom']['enabled'] = true
default['ruby-deployment-support']['package-name'] = 'ibm-iaccess'
default['ruby-deployment-support']['server']['environment'] = 'development'
default['ruby-deployment-support']['server']['name'] = 'marvel'
default['ruby-deployment-support']['server']['address'] = 'marvel.ent.gci'
default['ruby-deployment-support']['server']['port'] = '3820'
default['ruby-deployment-support']['server']['username'] = 'test_user'
default['ruby-deployment-support']['server']['adapter'] = 'mysqldb'
default['ruby-deployment-support']['config-dir'] = 'config'
default['ruby-deployment-support']['s3-config-bucket'] = 'gdp-commerce-configs'
default['ruby-deployment-support']['s3-fetcher']['user'] = 'rubyapp'
default['ruby-deployment-support']['db2']['install'] = false
default['ruby-deployment']['application']['migrate'] = true
default['ruby-deployment']['homedir'] = '/opt/rubyapp'
default['ruby-deployment']['user'] = 'rubyapp'
default['ruby-deployment']['application']['name'] = 'test'
default['ruby-deployment']['application']['env_vars'] =
  [{ 'name' => 'APPLICATION_EMAIL', 'value' => 'jrmoore@gannett.com' },
   { 'name' => 'APPLICATION_SECRET', 'value' => '\'7152545355345150537132565775425269766a51437879326e4e62377551447a7043436753423136427a4d5'\
   '04c7776796d396b6870634c515458344e0a39796f6355414137695573473775523745636d685a654d784544797'\
   '13462474162534d4272547632346b426c367a486d4f53466c4452366c446167330a364776794e6f44666c47533'\
   '652366e674f31456a70445461684f7a6b425869306a786b636c47394d656a54387a6f6275484b4e5448697a734'\
   'e4a33770a436862495a516850616d496d0a\'' }]
