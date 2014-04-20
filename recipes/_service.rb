# Encoding: UTF-8
# Recipe:: _service
#
#

directory File.dirname node[:etcd][:state_dir]

template '/etc/init/etcd.conf' do
  mode 0644
  variables(args: Etcd.args)
  notifies :restart, 'service[etcd]' if node[:etcd][:trigger_restart]
end

service 'etcd' do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
