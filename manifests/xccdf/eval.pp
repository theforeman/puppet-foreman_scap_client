#
# Copyright (c) 2014 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#

class openscap::xccdf::eval (

)
{
  include 'openscap::package'

  Class['openscap::package'] ->
  scap_schedule {'saturdays':
    period => weekly,
    weekday => 'Sat',
  } ->
  xccdf_scan {'weekly-ssg-audit':
    ensure => 'present',
    xccdf_path => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
    xccdf_profile => 'xccdf_org.ssgproject.content_profile_common',
    scap_schedule => 'saturdays',
  }
}
