default['logstash']['base_dir'] = '/opt/logstash'
default['logstash']['user'] = 'logstash'
default['logstash']['group'] = 'logstash'
default['logstash']['join_groups'] = []

default['logstash']['source_url'] = 'http://logstash.objects.dreamhost.com/release/logstash-1.1.10-flatjar.jar'
default['logstash']['checksum'] = 'c417e73ce136adb00fd9ace75b705c3ee353d8bb4f31e81ba121ce4955f2c32d'

default['logstash']['default_directories'] = %w{etc lib tmp}
default['logstash']['conf_dir'] = "/etc/logstash.d"
default['logstash']['patterns_dir'] = "#{node['logstash']['base_dir']}/etc/patterns"
default['logstash']['log_dir'] = '/var/log/logstash'
default['logstash']['pid_dir'] = '/var/run/logstash'
default['logstash']['create_account'] = true

default['logstash']['install_method'] = 'jar'
default['logstash']['version'] = '1.1.10'
default['logstash']['xms'] = '384M'
default['logstash']['xmx'] = '384M'
default['logstash']['java_opts'] = ''
default['logstash']['gc_opts'] = '-XX:+UseParallelOldGC'
default['logstash']['ipv4_only'] = false
default['logstash']['debug'] = false

# roles/flags for various search/discovery
default['logstash']['graphite_role'] = 'graphite_server'
default['logstash']['graphite_query'] = "roles:#{node['logstash']['graphite_role']} AND chef_environment:#{node.chef_environment}"
default['logstash']['elasticsearch_role'] = 'elasticsearch_server'
default['logstash']['elasticsearch_query'] = "roles:#{node['logstash']['elasticsearch_role']} AND chef_environment:#{node.chef_environment}"
default['logstash']['elasticsearch_cluster'] = 'logstash'
default['logstash']['elasticsearch_ip'] = ''
default['logstash']['elasticsearch_port'] = ''
default['logstash']['graphite_ip'] = ''

default['logstash']['patterns'] = {}

