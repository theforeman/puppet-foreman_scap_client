# Configures foreman_scap_client and sets cron tasks to run it
#
# === Parameters:
#
# $server::           foreman proxy url where arf reports should be sent
#
# $port::             port of foreman proxy that is used as $server
#
# $ca_file::          path to file of certification authority that issued client's certificate
#
# $host_certificate:: path to host certificate, usually puppet agent certificate
#
# $host_private_key:: path to host private key, usually puppet agent private key
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
  $server,
  $port,
  $ca_file          = '/var/lib/puppet/ssl/certs/ca.pem',
  $host_certificate = "/var/lib/puppet/ssl/certs/${fqdn}.pem",
  $host_private_key = "/var/lib/puppet/ssl/private_keys/${fqdn}.pem",
  $policies,
) {
  $policies_array = flatten([$policies])
  $policies_yaml = inline_template('<%= Hash[policies_array.map { |p|
      ["foreman_scap_client_#{p["id"]}",
        {
          "command" => "/usr/bin/foreman_scap_client #{p[\'id\']}",
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

  package { 'rubygem-foreman_scap_client': } ->
  file { 'foreman_scap_client':
    path    => '/etc/foreman_scap_client/config.yaml',
    content => template('foreman_scap_client/config.yaml.erb'),
    owner   => 'root',
    ensure  => present,
  }

  create_resources(cron, $policies_data)
}
