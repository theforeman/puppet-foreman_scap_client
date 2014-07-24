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
# = Class: openscap::xccdf::foreman_audit
#
# This class ensures that client system is evaluated against given
# XCCDF guidance. The class supports reoccuring scans. The results
# are stored at the client system and uploaded to the remote location.
#
#
# == Parameters:
#
# $xccdf_path:: Path to XCCDF or DataStream file
# $xccdf_profile:: XCCDF Profile to evaluate
# $period:: How often the evaluation shall happen
# $weekday:: Preferable weekday for evaluation to happen
# $content_package:: Package which includes $xccdf_path
# $scan_name:: The identifier of the reoccuring scan on the disk
# $foreman_proxy:: The URI of Foreman's Proxy to receive the audit results
#
# Default arguments will evaluate SCAP-Security-Guide policy in
# a weekly manner. The results will be uploaded to the puppetmaster.
# That assumes that Puppet Master is managed by Foreman's Smart Proxy.
#
# == Sample Usage:
#
#   class {openscap::xccdf::foreman_audit:
#     name => 'my-weekly-audit',
#     period => 'weekly',
#     weekday => 'Fri',
#     foreman_proxy = 'https://foreman-proxy-01.local.lan:8443',
#   }
#

class openscap::xccdf::foreman_audit (
  $xccdf_path = $openscap::params::xccdf_path,
  $xccdf_profile = $openscap::params::xccdf_profile,
  $content_package = $openscap::params::content_package,
  $period = $openscap::params::period,
  $weekday = $openscap::params::weekday,
  $scan_name = 'untitled',
  $foreman_proxy = ''
) inherits openscap::params
{
  validate_string($xccdf_path)

  include 'openscap::package'

  scap_schedule {'scap-schedule':
    period => $period,
    weekday => $weekday,
  }
  scap_upload {'storage':
    foreman_proxy => $foreman_proxy,
  }

  Class['openscap::package'] ->
  xccdf_scan {$scan_name:
    ensure => 'present',
    xccdf_path => $xccdf_path,
    xccdf_profile => $xccdf_profile,
    scap_schedule => 'scap-schedule',
    scap_upload => 'storage',
  }
}
