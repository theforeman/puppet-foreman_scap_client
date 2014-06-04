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

  newparam(:weekday) do
    desc "The days of the week in which the schedule should be valid.
          You may specify the full day name (Tuesday), the three character
          abbreviation (Tue)"
    validate do |values|
      values = [values] unless values.is_a?(Array)
      values.each { |value|
        raise ArgumentError, "%s is not a valid day of the week" % value unless value.is_a?(String) and
            (value =~ /^[0-6]$/ or value =~ /^(Mon|Tues?|Wed(?:nes)?|Thu(?:rs)?|Fri|Sat(?:ur)?|Sun)(day)?$/i)
      }
    end

    weekdays = {'sun' => 0, 'mon' => 1, 'tue' => 2, 'wed' => 3, 'thu' => 4, 'fri' => 5, 'sat' => 6}

    munge do |values|
      values = [values] unless values.is_a?(Array)
      ret = {}

      values.each { |value|
        if value =~ /^[0-6]$/
          index = value.to_i
        else
          index = weekdays[value[0,3].downcase]
        end
        ret[index] = true
      }
      ret
    end
  end

  def get_filename
    _last_matching_day.strftime('%Y-%m-%d') + '.rds.xml'
  end

  private
  def _last_matching_day
    Date.today.downto(Date.today << 2) do |d|
      return d if case self[:period]
        when :daily then true
        when :weekly then
          self[:weekday] ? _matches_wday(d) : d.monday?
        when :monthly then
          self[:weekday] ? (d.mday <= 7 and _matches_wday(d)) : d.mday == 1
      end
    end
    raise 'No candidate scan day found.'
  end

  def _matches_wday(day)
    self[:weekday] ? self[:weekday][day.wday] : true
  end
end
