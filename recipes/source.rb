include_recipe "build-essential"
include_recipe "java"
include_recipe "ant"
include_recipe "git"
include_recipe "logstash::default"

package "wget"

logstash_version = node['logstash']['source']['sha'] || "v#{node['logstash']['server']['version']}"

directory "#{node['logstash']['base_dir']}/source" do
  action :create
  owner node['logstash']['user']
  group node['logstash']['group']
  mode "0755"
end

git "#{node['logstash']['base_dir']}/source" do
  repository node['logstash']['source']['repo']
  reference logstash_version
  action :sync
  user node['logstash']['user']
  group node['logstash']['group']
end

execute "build-logstash" do
  cwd "#{node['logstash']['base_dir']}/source"
  environment ({'JAVA_HOME' => node['logstash']['source']['java_home']})
  user "root"
  # This variant is useful for troubleshooting stupid environment problems
  # command "make clean && make VERSION=#{logstash_version} --debug > /tmp/make.log 2>&1"
  command "make clean && make VERSION=#{logstash_version}"
  action :run
  creates "#{node['logstash']['base_dir']}/source/build/logstash-#{logstash_version}-monolithic.jar"
  not_if "test -f #{node['logstash']['base_dir']}/source/build/logstash-#{logstash_version}-monolithic.jar"
end
