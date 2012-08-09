nodes = search(:node, "*:*")
hosts = nodes.map do |node|
  {
    :hostname => node.name,
    :ipaddress => node[:ipaddress]
  }
end

local_file = cookbook_file "/etc/hosts.local" do
  owner "root"
  group "root"
  mode  0644
  cookbook "hosts"
  source "hosts.local"
  action :nothing
end

local_file.run_action(:create)

template "/etc/hosts" do
  mode 0644
  owner "root"
  group "root"
  source "hosts.erb"
  variables(:nodes => hosts, :localdata => IO.read('/etc/hosts.local'))
end

