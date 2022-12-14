# Params class for parent foreman_scap_client
# @api private
class foreman_scap_client::params {
  $ssl_dir = '/etc/puppetlabs/puppet/ssl'

  $ca_file          = pick($facts['rh_certificate_repo_ca_file'], "${ssl_dir}/certs/ca.pem")
  $host_certificate = pick($facts['rh_certificate_consumer_host_cert'], "${ssl_dir}/certs/${trusted['certname']}.pem")
  $host_private_key = pick($facts['rh_certificate_consumer_host_key'], "${ssl_dir}/private_keys/${trusted['certname']}.pem")
}
