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
* 'foreman_repo_rel': add / manage foreman-plugins yum repo and set to release version. Eg  '1.14'
* 'foreman_repo_key': RPM Key source file for foreman-plugins repo. Note: Currently, packages are not signed. 
Unless set to an alternative file source, URL will be used.
* 'foreman_repo_src':  Alternative baseurl for The Foreman plugins repository
* 'foreman_repo_gpg_chk': Enable / disable GPG checks. Directly passed to Yumrepo resource

For detailed info on the parameters see documentation on manifests/init.pp & manifests/params.pp

### Sample Usage

The following example ensures that every week an SCAP audit is executed and the results
are sent to proxy at proxy.example.com. The example will automatically attempt to install
foreman_scap_client on the system. If you do not wish to use your tailoring file with policy,
just pass empty string to "tailoring_path".

```puppet
class { foreman_scap_client:
  server           => 'proxy.example.com',
  port             => '8443',
  foreman_repo_rel => '1.14',
  foreman_repo_key => '/net/share/foreman-gpg-rpm-key',
  policies         => [{ 
    "id"                      => 1, 
    "hour"                    => "12", 
    "minute"                  => "1", 
    "month"                   => "*",
    "monthday"                => "*", 
    "weekday"                 => "1", 
    "profile_id"              => '',
    "content_path"            => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
    "download_path"           => '/compliance/policies/1/content',
    "tailoring_path"          => '/var/lib/openacap/ssg-fedora-ds-tailored.xml',
    "tailoring_download_path" => "/compliance/policies/1/tailoring" 
  }]
}
```

### Usage with foreman_openscap
When using this module together with [foreman_openscap](https://theforeman.org/plugins/foreman_openscap/), no further configuration
 should be necessary as values are by Foreman's ENC. However, verify the values for server, port and policies after
 importing the class; the policies should be `<%= @host.policies_enc %>`


### Releasing on puppet forge

We use project blacksmith to do the release. All you need to do is configuring theforeman
credentials in ~/.puppetforge.yml and then call release task from upstream repo like this

```
bundle exec rake module:release
```
