#
# Cookbook:: chef-server-test
# Recipe:: default
package 'chefServer' do
	package_name 'chef-server-core'
	default_release 'stable'
	version 'latests'
	action :install
end	
# Copyright:: 2021, The Authors, All Rights Reserved.
