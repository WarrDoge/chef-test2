describe package('chef-server-core.x86_64') do
  it { should be_installed }
  its('version') { should eq '14.4.4-1.el7' }
end
describe command('chef-server-ctl user-list') do
  its('stdout') { should eq "admin\npivotal\n" }
end
describe command('chef-server-ctl org-list') do
  its('stdout') { should eq "someorg\n" }
end