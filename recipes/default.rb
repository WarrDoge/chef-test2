# Cookbook:: chef-server-test
# Recipe:: default


# ---------------
# Install package
# ---------------
packageSource = node['packageSource']
packageName = node['packageName']
rpm_package 'chefServerCoreInstall' do
  source packageSource
  package_name packageName
  action :install
end 


# -----------------------------------
# Chef reconfigure and accept license
# -----------------------------------
execute 'chefReconfigure' do
  command 'chef-server-ctl reconfigure --chef-license accept'
  not_if 'ls /etc/opscode | grep -q pivotal'
end


# ------------------------------------
# Create user and org, add user to org
# ------------------------------------
orgName = node['orgName']
orgFullName = node['orgFullName']
user = node['userName']
userMail = node['userMail']
userPass = (0...10).map { ('a'..'z').to_a[rand(10)] }.join
File.write("pass.txt", "user: #{user}\nemail: #{userMail}\npassword: #{userPass}\n", mode: "a")
execute 'chefCreateAdmin' do
  command "chef-server-ctl user-create #{user} #{user} #{user} #{userMail} #{userPass} && chef-server-ctl org-create #{orgName} ""#{orgFullName}"" -a #{user}"
  not_if "chef-server-ctl user-list | grep -q #{user}"
end


=begin --> old
  
# ---------------------------
# Create org and attache user
# ---------------------------
orgName = node['orgName']
orgFullName = node['orgFullName']
execute 'chefCreateOrg' do
  command "chef-server-ctl org-create #{orgName} ""#{orgFullName}"" -a #{user}"
  not_if "chef-server-ctl org-list | grep -q #{orgName}"
end