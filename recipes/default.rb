#
# Cookbook:: chef-server-test
# Recipe:: default


# -----------
# From source
# -----------

directory "/chef" do
	action :create	
end


remote_file '/chef/chef-server-core-14.4.4-1.el7.x86_64.rpm' do
	source 'https://packages.chef.io/files/stable/chef-server/14.4.4/el/7/chef-server-core-14.4.4-1.el7.x86_64.rpm'
	action :create_if_missing	
end


rpm_package 'chefServerCoreInstall' do
	package_name '/chef/chef-server-core-14.4.4-1.el7.x86_64.rpm'
	action :install
end	


execute 'chefReconfigure' do
	command 'chef-server-ctl reconfigure --chef-license accept'
end


execute 'chefCreateAdmin' do
	command 'chef-server-ctl user-create admin admin admin my@email.com root' #-f /etc/chef/admin.pem'
end


execute 'chefCreateOrg' do
	command 'chef-server-ctl org-create newOrg -a admin'
end


# Copyright:: 2021, The Authors, All Rights Reserved.