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

require 'openscap' if Puppet.features.openscap?

Puppet::Type.type(:xccdf_scan).provide :openscap do

  confine :feature => :openscap

  commands :bzip2 => "/usr/bin/bzip2"

  def exists?
    return File::exist? _target_location_rds + ".bz2"
  end

  def create
    FileUtils.mkdir_p _target_location_dir
    begin
      session = OpenSCAP::Xccdf::Session.new(resource[:xccdf_path])
      session.load
      session.profile = resource[:xccdf_profile] unless resource[:xccdf_profile] == ''
      session.evaluate
      session.export_results(rds_file: _target_location_rds)
    ensure
      session.destroy
    end
    bzip2 _target_location_rds
  end


  private

  def _target_location_dir
    return '/var/lib/openscap/xccdf_scan/' + resource[:name] + '/'
  end

  def _target_location_rds
    return _target_location_dir + _rds_filename
  end

  def _rds_date
    schedule = resource[:scap_schedule] ? @resource.catalog.resource(:scap_schedule, resource[:scap_schedule]) : nil
    (schedule ? schedule.last_matching_day : Date.today).strftime('%Y-%m-%d')
  end

  def _rds_filename
    _rds_date + '.rds.xml'
  end
end
