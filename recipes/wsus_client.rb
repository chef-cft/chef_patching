#
# Bootstrap
#
powershell_script 'Create config.rb' do
  code <<-EOH
  $nodeName = "WSUS-Client-{0}" -f (-join ((65..90) + (97..122) | Get-Random -Count 4 | % {[char]$_}))

  $clientrb = @"
chef_server_url 'https://#{node['environment']['automate_url']}/organizations/#{node['environment']['chef_org']}'
validation_key 'C:\\Users\\Administrator\\AppData\\Local\\Temp\\kitchen\\cookbooks\\chef_patching\\recipes\\validator.pem'
node_name '{0}'
policy_group 'development'
policy_name 'patching'
ssl_verify_mode :verify_none
chef_license 'accept'
"@ -f $nodeName

  Set-Content -Path c:\\chef\\client.rb -Value $clientrb

  C:\\opscode\\chef\\bin\\chef-client.bat
  EOH
  not_if { ::File.exist?('c:\chef\client.rb') }
end

powershell_script 'Run Chef' do
  code <<-EOH
  ## Run Chef
  C:\\opscode\\chef\\bin\\chef-client.bat
  EOH
end
#
# WSUS-Client
#
include_recipe 'wsus-client::update'