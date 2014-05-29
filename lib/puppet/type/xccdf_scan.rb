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

Puppet::Type.newtype(:xccdf_scan) do
  @doc = "Creates an SCAP report directory with SCAP result files"
  ensurable

  newparam(:name, :namevar => true) do
    desc "Name of the SCAP report"
    munge do |value|
      value.downcase
    end
    def insync?(is)
      is.downcase == should.downcase
    end
  end

  newparam(:xccdf_path) do
    desc "Path to XCCDF or DataStream file."
    validate do |value|
      unless File::exists? value
        raise ArgumentError, "%s is not valid file path" % value
      end
    end
  end

  newparam(:xccdf_profile) do
    desc "ID of XCCDF Profile"
  end
end
