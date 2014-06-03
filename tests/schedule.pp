scap_schedule {'everyday':
  period => daily,
}
scap_schedule {'everyweek':
  period => weekly,
}
scap_schedule {'everymonth':
  period => monthly,
}

xccdf_scan {'my-daily-scan':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
  xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
  scap_schedule => 'everyday',
}
xccdf_scan {'my-weekly-scan':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
  xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
  scap_schedule => 'everyweek',
}
xccdf_scan {'my-monthly-scan':
  ensure => 'present',
  xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
  xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
  scap_schedule => 'everymonth',
}
