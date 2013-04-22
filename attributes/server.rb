default['logstash']['server']['base_config'] = 'server.conf.erb'
default['logstash']['server']['base_config_cookbook'] = 'logstash'

# roles/flags for various autoconfig/discovery components
default['logstash']['server']['enable_embedded_es'] = true

default['logstash']['server']['inputs'] = [{
  :tcp => {
    :type => 'tcp-input',
    :port => '5959',
    :format => 'json_event'
  }
}]
default['logstash']['server']['filters'] = []
default['logstash']['server']['outputs'] = []


