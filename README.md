#OpenSCAP Puppet Module

OpenSCAP Puppet Module exposes OpenSCAP primitives to puppet DSL.

## Examplary Usage
The following example ensures that every week an SCAP audit is executed and the results are stored under /var/lib/openscap directory. The OpenSCAP Puppet module ensures that the last audit result is present. I.e. if puppet is not run on Saturday, the audit is executed with the next puppet run. The example assumes scap-security-guide package is installed on the system.

```
scap_schedule {'saturdays':
  period => weekly,
  weekday => 'Sat',
}

xccdf_scan {'weekly-ssg-audit':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
  xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
  scap_schedule => 'saturdays',
}
```
