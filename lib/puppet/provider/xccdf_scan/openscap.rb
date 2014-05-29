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

require 'openscap'

Puppet::Type.type(:xccdf_scan).provide :openscap do
  def exists?
    return File::exist? _target_location_rds
  end

  def create
    Dir.mkdir('/tmp/xccdf_scan/')
    session = OpenSCAP::Xccdf::Session.new("/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml")
    session.load
    session.profile = "xccdf_org.ssgproject.content_profile_common"
    session.evaluate
    session.export_results(rds_file: _target_location_rds)
  end


  private

  def _target_location_dir
    return '/tmp/xccdf_scan/'
  end

  def _target_location_rds
    return _target_location_dir + "results.rds.xml"
  end
end
