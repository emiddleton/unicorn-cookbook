#
# Cookbook Name:: unicorn
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
# unicorn application server
#

portage_overlay 'chef-gentoo-bootstrap-overlay'

{
    'dev-ruby/raindrops'  => '0.7.0',  # overlay
    'dev-ruby/kgio'       => '2.6.0',  # overlay
  'www-servers/unicorn'  => '4.1.1'    # overlay
}.each do |package_name,package_version|
  portage_package_keywords "=#{package_name}-#{package_version}"
end

package 'www-servers/unicorn' do
  version '4.1.1'
end

directory '/var/run/unicorn' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/var/log/unicorn' do
  owner 'root'
  group 'root'
  mode '0755'
end
