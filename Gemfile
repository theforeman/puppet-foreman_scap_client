source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.6']
end

gem 'rake'
gem 'puppet', puppetversion
gem 'openscap', '>= 0.1.1'
gem 'puppetlabs_spec_helper', '>= 0.8.0'
gem 'puppet-blacksmith', '>= 3.1.0', {"groups"=>["development"]}
