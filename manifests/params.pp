class foreman_scap_client::params {
  $downcased_fqdn = downcase($fqdn)
  if versioncmp('4.0.0', $clientversion) > 0 {
    $ssl_dir = '/var/lib/puppet/ssl'
  } else {
    $ssl_dir = '/etc/puppetlabs/puppet/ssl'
  }

  $ca_file          = pick($::rh_certificate_repo_ca_file, "${ssl_dir}/certs/ca.pem")
  $host_certificate = pick($::rh_certificate_consumer_host_cert, "${ssl_dir}/certs/${$downcased_fqdn}.pem")
  $host_private_key = pick($::rh_certificate_consumer_host_key, "${ssl_dir}/private_keys/${$downcased_fqdn}.pem")
}
