xccdf_scan {'mine-scan':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
  xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
}
