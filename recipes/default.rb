# Cookbook:: chef-server-test
# Recipe:: default

# ---------------
# Install package
# ---------------
pkg_source = node['pkg_source']
pkg_name = node['pkg_name']

rpm_package pkg_name do
  source pkg_source
  action :install
end 

# -----------------------------------
# Chef reconfigure and accept license
# -----------------------------------
execute 'chef_reconfigure' do
  command 'chef-server-ctl reconfigure --chef-license accept'
  not_if 'ls /etc/opscode | grep -q -w pivotal.rb'
end

# -----------
# Create user
# -----------
user_name = node['user_name'][node['current_user'] - 1]
user_mail = node['user_mail'][node['current_user'] - 1]
user_pass = (0...10).map { ('a'..'z').to_a[rand(50)] }.join
org_name = node['org_name']
org_full_name = node['org_full_name']

execute 'chef_create_user' do
  command "chef-server-ctl user-create #{user_name} #{user_name} #{user_name} #{user_mail} #{user_pass}"
  not_if "chef-server-ctl user-list | grep -q -w #{user_name}"
end

# --------------
# Save user pass
# --------------
file "/#{user_name}.txt" do
  content "#{user_pass}"
  mode '700'
  owner 'root'
  group 'root'
  not_if "ls / | grep -q -w #{user_name}.txt"
end

# ----------
# Create org
# ----------
org_name = node['org_name']
org_full_name = node['org_full_name']
execute 'chef_create_org' do
  command "chef-server-ctl org-create #{org_name} '#{org_full_name}'"
  not_if "chef-server-ctl org-list | grep -q -w #{org_name}"
end

# ---------------
# Add user to org
# ---------------
execute 'chef_add_user_to_org' do
  command "chef-server-ctl org-user-add #{org_name} #{user_name}"
end