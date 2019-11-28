# Params class for parent foreman_scap_client
class foreman_scap_client::params {
  $downcased_fqdn = downcase($::fqdn)
  $ssl_dir = '/etc/puppetlabs/puppet/ssl'

  # Set CA file
  if defined('$::rh_certificate_repo_ca_file') {
    $rh_certificate_repo_ca_file = $::rh_certificate_repo_ca_file
  }
  else {
    $rh_certificate_repo_ca_file = undef
  }

  # Set host cert
  if defined('$::rh_certificate_consumer_host_cert') {
    $rh_certificate_consumer_host_cert = $::rh_certificate_consumer_host_cert
  }
  else {
    $rh_certificate_consumer_host_cert = undef
  }

  # Set private key
  if defined('$::rh_certificate_consumer_host_key') {
    $rh_certificate_consumer_host_key = $::rh_certificate_consumer_host_key
  }
  else {
    $rh_certificate_consumer_host_key = undef
  }

  $package_name = $::osfamily ? {
    'Debian' => 'ruby-foreman-scap-client',
    default  => 'rubygem-foreman_scap_client'
  }

  $ca_file          = pick($rh_certificate_repo_ca_file, "${ssl_dir}/certs/ca.pem")
  $host_certificate = pick($rh_certificate_consumer_host_cert, "${ssl_dir}/certs/${$downcased_fqdn}.pem")
  $host_private_key = pick($rh_certificate_consumer_host_key, "${ssl_dir}/private_keys/${$downcased_fqdn}.pem")
}
