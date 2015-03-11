#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "httpd" do
  action :install
end

service "httpd" do
  action [:enable, :start]
end

execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/elcome.conf.disabled" do
  only_if {File.exist?('/etc/httpd/conf.d/welcome.conf'}
  notifies :restart, 'service[httpd]'
end

node["apache"]["sites"].each do |site_name,site_data|

  document_root = "/srv/apache/#{site_name}"


  template "/etc/httpd /conf.d/#{site_name}.conf.d" do
    source 'custom.erb'
    mode '0644'
    variables(
        document_root: document_root,
        port: site_data["port"]
      )
    notifies :restart, 'service[httpd]'
  end

  directory "#{document_root}" do
    mode '0755'
    recursive :true
    action :create
  end

  template "#{document_root}/index.html" do
    source 'index.html.erb'
    mode '0644'
    variables(
      site_name: site_name,
      port: site_data["port"]
      )
  end


end


