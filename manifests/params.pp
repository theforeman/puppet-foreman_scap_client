class foreman_scap_client::params {
  $fqdn_s = downcase($fqdn)
  $ca_file          = pick($::rh_certificate_repo_ca_file, '/var/lib/puppet/ssl/certs/ca.pem')
  $host_certificate = pick($::rh_certificate_consumer_host_cert, "/var/lib/puppet/ssl/certs/${fqdn_s}.pem")
  $host_private_key = pick($::rh_certificate_consumer_host_key, "/var/lib/puppet/ssl/private_keys/${fqdn_s}.pem")
}