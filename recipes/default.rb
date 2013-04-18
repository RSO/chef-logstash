#
# Cookbook Name:: logstash
# Recipe:: default
#
include_recipe 'runit' unless node['platform_version'] == '12.04'
include_recipe 'java'
include_recipe 'logrotate'

# Create user if nessecary
if node['logstash']['create_account']
  group node['logstash']['group'] do
    system true
  end

  user node['logstash']['user'] do
    group node['logstash']['group']
    home "/var/lib/logstash"
    system true
    action :create
    manage_home true
  end
end

node['logstash']['join_groups'].each do |grp|
  group grp do
    members node['logstash']['user']
    action :modify
    append true
    only_if "grep -q '^#{grp}:' /etc/group"
  end
end

# Setup default directory structure
directories = [
    node['logstash']['base_dir'],
    node['logstash']['conf_dir'],
    node['logstash']['patterns_dir'],
    node['logstash']['log_dir']
  ] + node['logstash']['default_directories']

directories.each do |dir|
  directory "#{node['logstash']['base_dir']}/#{dir}" do
    mode 07755
    owner node['logstash']['user']
    group node['logstash']['group']
    recursive true
  end
end

# Installation
if node['logstash']['install_method'] == 'jar'
  remote_file "#{node['logstash']['base_dir']}/lib/logstash-#{node['logstash']['version']}.jar" do
    owner 'root'
    group 'root'
    mode 00755
    source node['logstash']['server']['source_url']
    checksum node['logstash']['server']['checksum']
    action :create_if_missing
  end

  link "#{node['logstash']['base_dir']}/lib/logstash.jar" do
    to "#{node['logstash']['base_dir']}/lib/logstash-#{node['logstash']['version']}.jar"
    notifies :restart, 'service[logstash_server]'
  end
else
  include_recipe 'logstash::source'

  logstash_version = node['logstash']['source']['sha'] || "v#{node['logstash']['version']}"
  link "#{node['logstash']['base_dir']}/lib/logstash.jar" do
    to "#{node['logstash']['base_dir']}/source/build/logstash-#{logstash_version}-monolithic.jar"
    notifies :restart, 'service[logstash_server]'
  end
end

# Setup patterns
node['logstash']['patterns'].each do |filename, hash|
  template "#{node['logstash']['patterns_dir']}/#{filename}" do
    source 'patterns.erb'
    owner node['logstash']['user']
    group node['logstash']['group']
    variables( :patterns => hash )
    mode 00644
    notifies :restart, 'service[logstash_agent]'
  end
end

# Setup logrotate
logrotate_app 'logstash' do
  path "#{node['logstash']['log_dir']}/*.log"
  frequency 'daily'
  rotate '30'
  options [ 'missingok', 'notifempty' ]
  create "664 #{node['logstash']['user']} #{node['logstash']['group']}"
end
