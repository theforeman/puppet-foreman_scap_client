# Configures foreman_scap_client and sets cron tasks to run it
#
# === Parameters:
#
# $ensure::           Passed to the rubygem-foreman_scap_client package.
#                     Default: present
#
# $server::           foreman proxy url where arf reports should be sent
#
# $port::             port of foreman proxy that is used as $server
#
# $ca_file::          path to file of certification authority that issued client's certificate
#                     May be overriden if $::rh_certificate_repo_ca_file (from Facter) is found
#
# $host_certificate:: path to host certificate, usually puppet agent certificate
#                     May be overriden if $::rh_certificate_consumer_host_cert (from Facter) is found
#
# $host_private_key:: path to host private key, usually puppet agent private key
#                     May be overriden if $::rh_certificate_consumer_host_key (from Facter) is found
#
# $policies::         Array of policies that should be configured, each member represent
#                     one policy in form of hash
#                     Policy hash must have following structure
#
#                       { "id" => 1, "hour" => "*", "minute" => "*", "month" => "*",
#                         "monthday" => "*", "weekday" => "*", "profile_id" => '',
#                         "content_path" => '/usr/share/...' }
#
#                     note that profile_id may be empty (for default profile)
#                     id is number representing id of policy in foreman
#                     content_path is path to DS file that contains profile
#
#                     if it's not array, it's automatically converted to it, so you can
#                     even specify just one policy as a hash
#                     type:array
class foreman_scap_client(
  $ensure           = 'present',
  $server,
  $port,
  $ca_file          = $::foreman_scap_client::params::ca_file,
  $host_certificate = $::foreman_scap_client::params::host_certificate,
  $host_private_key = $::foreman_scap_client::params::host_private_key,
  $policies,
) inherits foreman_scap_client::params {
  $policies_array = flatten([$policies])
  $policies_yaml = inline_template('<%= Hash[@policies_array.map { |p|
      ["foreman_scap_client_#{p["id"]}",
        {
          "command" => "/usr/bin/foreman_scap_client #{p[\'id\']} > /dev/null",
          "user" => "root",
          "hour" => p["hour"],
          "minute" => p["minute"],
          "month" => p["month"],
          "monthday" => p["monthday"],
          "weekday" => p["weekday"],
        }
      ]
    }].to_yaml %>')
  $policies_data = parseyaml($policies_yaml)

  package { 'rubygem-foreman_scap_client': ensure => $ensure, } ->
  file { 'foreman_scap_client':
    path    => '/etc/foreman_scap_client/config.yaml',
    content => template('foreman_scap_client/config.yaml.erb'),
    owner   => 'root',
    ensure  => present,
  }

  create_resources(cron, $policies_data)
}
