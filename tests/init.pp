xccdf_scan {'mine-scan':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml'
}
