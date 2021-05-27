describe package('chef-server-core.x86_64') do
  it { should be_installed }
end

describe command('chef-server-ctl user-list') do
  its('stdout') { should include "admin" }
end

describe command('chef-server-ctl org-list') do
  its('stdout') { should include "someorg" }
end