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

require 'net/https'
require 'openscap' if Puppet.features.openscap?

Puppet::Type.type(:xccdf_scan).provide :openscap do

  confine :feature => :openscap

  commands :bzip2 => "/usr/bin/bzip2"

  def exists?
    return File::exist? result_path
  end

  def create
    begin
      FileUtils.mkdir_p _target_location_dir
      begin
        session = OpenSCAP::Xccdf::Session.new(resource[:xccdf_path])
        session.load
        session.profile = resource[:xccdf_profile] unless resource[:xccdf_profile] == ''
        session.evaluate
        session.export_results(:rds_file => _target_location_rds)
      ensure
        session.destroy
      end
      bzip2 _target_location_rds
      scap_upload.provider.upload self if scap_upload
    rescue Exception => e
      delete if exists?
      raise
    end
  end

  def delete
    File.unlink result_path
  end

  def scap_upload
    resource[:scap_upload] ? @resource.catalog.resource(:scap_upload, resource[:scap_upload]) : nil
  end

  def policy_name
    resource[:name]
  end

  def date
    schedule = resource[:scap_schedule] ? @resource.catalog.resource(:scap_schedule, resource[:scap_schedule]) : nil
    (schedule ? schedule.last_matching_day : Date.today).strftime('%Y-%m-%d')
  end

  def result_path
    _target_location_rds + '.bz2'
  end

  private

  def _target_location_dir
    return '/var/lib/openscap/xccdf_scan/' + policy_name + '/'
  end

  def _target_location_rds
    return _target_location_dir + date + '.rds.xml'
  end
end
