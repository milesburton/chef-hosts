# Set the hostname to the node name

case node['platform']                                                                                                                                                                                                
when "redhat", "centos", "fedora", "suse", "amazon"
  bash "update network file" do
    code <<-EOH
        if [ -z `cat /etc/sysconfig/network | grep HOSTNAME` ]; then
              echo "HOSTNAME=#{node.name}" >> /etc/sysconfig/network
        else
              sed -i -e "s/\(HOSTNAME=\).*/\1#{node.name}/" /etc/sysconfig/network
        fi
        hostname #{node.name}
        EOH
    cwd "/tmp"
  end

when "debian", "ubuntu" 
  service "hostname" do
    action :none
    provider Chef::Provider::Service::Upstart
  end

  file "/etc/hostname" do
    content node.name
    notifies :restart, resources("service[hostname]")
  end
end
