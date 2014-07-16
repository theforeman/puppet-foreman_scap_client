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
#
# = Class: openscap::xccdf::eval
#
# This class ensures that client system is evaluated against given
# XCCDF guidance. The class supports reoccuring scans. The results
# are stored at the client system.
#
#
# == Parameters:
#
# $xccdf_path:: Path to XCCDF or DataStream file
# $xccdf_profile:: XCCDF Profile to evaluate
# $period:: How often the evaluation shall happen
# $period:: Preferable weekday for evaluation to happen
# $content_package:: Package which includes $xccdf_path
# $scan_name:: The identifier of the reoccuring scan on the disk
#
# Default arguments will evaluate SCAP-Security-Guide policy in
# a weekly manner.
#
# == Sample Usage:
#
#   class {'my-weekly-audit':
#     period => 'weekly',
#     weekday => 'Fri',
#   }
#

class openscap::xccdf::eval (
  $xccdf_path = $openscap::params::xccdf_path,
  $xccdf_profile = $openscap::params::xccdf_profile,
  $content_package = $openscap::params::content_package,
  $period = $openscap::params::period,
  $weekday = $openscap::params::weekday,
  $scan_name = 'untitled',
) inherits openscap::params
{
  validate_string($xccdf_path)

  include 'openscap::package'

  Class['openscap::package'] ->
  scap_schedule {'scap-schedule':
    period => $period,
    weekday => $weekday,
  } ->
  xccdf_scan {$scan_name:
    ensure => 'present',
    xccdf_path => $xccdf_path,
    xccdf_profile => $xccdf_profile,
    scap_schedule => 'scap-schedule',
  }
}
