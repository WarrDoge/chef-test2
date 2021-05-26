#
# Cookbook:: chef-server-test
# Recipe:: default


# -----------
# From source
# -----------

# Create a package directory
directory "/chef" do
	action :create	
end


# Download package
remote_file '/chef/chef-server-core-14.4.4-1.el7.x86_64.rpm' do
	source 'https://packages.chef.io/files/stable/chef-server/14.4.4/el/7/chef-server-core-14.4.4-1.el7.x86_64.rpm'
	action :create_if_missing	
end


# Install package
rpm_package 'chefServerCoreInstall' do
	package_name '/chef/chef-server-core-14.4.4-1.el7.x86_64.rpm'
	action :install
end	


# Chef reconfigure and accept license
execute 'chefReconfigure' do
	command 'chef-server-ctl reconfigure --chef-license accept'
end


# Create User
execute 'chefCreateAdmin' do
	command 'chef-server-ctl user-create admin admin admin my@email.com root228' #-f /etc/chef/admin.pem
	not_if 'chef-server-ctl user-list | grep -q admin'
end


# Create org and attache user
execute 'chefCreateOrg' do
	command 'chef-server-ctl org-create someorg "voprosovNet" -a admin'
	not_if 'chef-server-ctl org-list | grep -q someorg'
end


# Copyright:: 2021, The Authors, All Rights Reserved.