#OpenSCAP Puppet Module

OpenSCAP Puppet Module exposes OpenSCAP primitives to puppet DSL.

## Examplary Usage
```
xccdf_scan{'my-ssg-audit':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
  xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
}
```
