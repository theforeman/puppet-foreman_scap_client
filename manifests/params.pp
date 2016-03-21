class foreman_scap_client::params {
  $downcased_fqdn = downcase($fqdn)
  $ca_file          = pick($::rh_certificate_repo_ca_file, '/var/lib/puppet/ssl/certs/ca.pem')
  $host_certificate = pick($::rh_certificate_consumer_host_cert, "/var/lib/puppet/ssl/certs/${$downcased_fqdn}.pem")
  $host_private_key = pick($::rh_certificate_consumer_host_key, "/var/lib/puppet/ssl/private_keys/${$downcased_fqdn}.pem")
}
