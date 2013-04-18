#
# Cookbook Name:: logstash
# Recipe:: agent
#
#
include_recipe 'logstash'

if node['logstash']['agent']['server_ipaddress']
  logstash_server_ip = node['logstash']['agent']['server_ipaddress']
elsif Chef::Config[:solo]
  Chef::Log.error('No server ipaddress provided while running Chef Solo')
  Chef::Application.fatal!('No server ipaddress provided while running Chef Solo')
else
  logstash_server_results = search(:node, "roles:#{node['logstash']['agent']['server_role']}")

  logstash_server_ip = logstash_server_results[0]['ipaddress'] unless logstash_server_results.empty?
end

if platform_family? 'debian'
  if ['12.04', '12.10'].include? node['platform_version']
    template '/etc/init/logstash_agent.conf' do
      mode 00644
      source 'logstash_agent.conf.erb'
    end

    service 'logstash_agent' do
      provider Chef::Provider::Service::Upstart
      action [ :enable, :start ]
    end
  else
    runit_service 'logstash_agent'
  end
elsif platform_family? 'rhel', 'fedora'
  template '/etc/init.d/logstash_agent' do
    source 'init.erb'
    owner 'root'
    group 'root'
    mode 00774
    variables(
      :config_file => 'shipper.conf',
      :name => 'agent',
      :max_heap => node['logstash']['agent']['xmx'],
      :min_heap => node['logstash']['agent']['xms']
    )
  end

  service 'logstash_agent' do
    supports :restart => true, :reload => true, :status => true
    action :enable
  end
end

template "#{node['logstash']['conf_dir']}/shipper.conf" do
  source node['logstash']['agent']['base_config']
  cookbook node['logstash']['agent']['base_config_cookbook']
  owner node['logstash']['user']
  group node['logstash']['group']
  mode 00644
  variables(
    :logstash_server_ip => logstash_server_ip,
    :patterns_dir => node['logstash']['patterns_dir']
  )
  notifies :restart, 'service[logstash_agent]'
end
