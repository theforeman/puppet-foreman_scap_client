# Params class for parent foreman_scap_client
# @api private
class foreman_scap_client::params {
  if 'rh_certificate' in $facts {
    $ca_file          = $facts['rh_certificate']['repo_ca_cert']
    $host_certificate = $facts['rh_certificate']['consumer_host_cert']
    $host_private_key = $facts['rh_certificate']['consumer_host_key']
  } else {
    $ssl_dir = '/etc/puppetlabs/puppet/ssl'
    $ca_file          = "${ssl_dir}/certs/ca.pem"
    $host_certificate = "${ssl_dir}/certs/${trusted['certname']}.pem"
    $host_private_key = "${ssl_dir}/private_keys/${trusted['certname']}.pem"
  }
}
