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

require 'date'

Puppet::Type.newtype(:scap_schedule) do
  @doc = "Defines date and time when the SCAP audit shall happen"

  newparam(:name, :namevar => true) do
    desc "Name of schedule definition"
    munge do |value|
      value.downcase
    end
    def insync?(is)
      is.downcase == should.downcase
    end
  end

  newparam(:period) do
    desc "The period of repetition for SCAP audits on this schedule."
    newvalues(:daily, :weekly, :monthly)
  end

  def get_filename
    _last_matching_day.strftime('%Y-%m-%d') + '.rds.xml'
  end

  private
  def _last_matching_day
    Date.today
  end
end
