#Foreman SCAP client Puppet Module

Foreman SCAP client Puppet Module configures foreman_scap_client
to run scans and upload results to foreman proxy.

## Configuration
This puppet module will automatically install foreman_scap_client (if not installed)
and will configure /etc/foreman_scap_client/config.yaml with parameters which are needed for the operation 
of foreman_scap_client.

### Parameters
* 'server': configures the proxy server
* 'port': configures the proxy server's port
* 'ca_file': path to file of certification authority that issued client's certificate
* 'host_certificate': path to host certificate, may be puppet agent certificate or katello certificate
* 'host_private_key': path to host private key, may be puppet agent private key or katello private key
* 'policies': Array of policies that should be configured

For detailed info on the parameters see documentation on manifests/init.pp & manifests/params.pp

### Sample Usage

The following example ensures that every week an SCAP audit is executed and the results
are sent to proxy at proxy.example.com. The example will automatically attempt to install
foreman_scap_client on the system.

```puppet
class { foreman_scap_client:
  server => 'proxy.example.com',
  port => '8443',
  policies => [ { "id" => 1, "hour" => "*", "minute" => "*", "month" => "*",
                  "monthday" => "*", "weekday" => "1", "profile_id" => '',
                  "content_path" => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
                  "download_path => '/compliance/policies/1/content' } ]
}
```
