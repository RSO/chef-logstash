default['logstash']['agent']['version'] = '1.1.10'
default['logstash']['agent']['source_url'] = 'http://logstash.objects.dreamhost.com/release/logstash-1.1.10-flatjar.jar'
default['logstash']['agent']['checksum'] = 'c417e73ce136adb00fd9ace75b705c3ee353d8bb4f31e81ba121ce4955f2c32d'
default['logstash']['agent']['base_config'] = 'agent.conf.erb'
default['logstash']['agent']['base_config_cookbook'] = 'logstash'

# roles/flasgs for various autoconfig/discovery components
default['logstash']['agent']['server_role'] = 'logstash_server'

# for use in case recipe used w/ chef-solo, default to self
default['logstash']['agent']['server_ipaddress'] = ''

default['logstash']['agent']['inputs'] = []
default['logstash']['agent']['filters'] = []
default['logstash']['agent']['outputs'] = []
