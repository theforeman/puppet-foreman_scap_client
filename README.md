#Foreman SCAP client Puppet Module

Foreman SCAP client Puppet Module configures the client of the same name
to run scans and upload results to foreman proxy.

### Sample Usage

The following example ensures that every week an SCAP audit is executed and the results
are sent to proxy at proxy.example.com. The example will automatically attempt to install
foreman_scap_client on the system.

```
class { foreman_scap_client:
  server => 'http://proxy.example.com',
  policies => [ { "id" => 1, "hour" => "*", "minute" => "*", "month" => "*",
                  "monthday" => "*", "weekday" => "1", "profile_id" => '',
                  "content_path" => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml' } ]
}
```

For more options and information, e.g. how to select other than default
profile, please see inline documentation of puppet class in manifests/init.pp file.


