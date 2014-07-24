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
    _upload
  end


  private

  def _upload
    uri = URI.parse(_upload_uri)
    self.info "Uploading results to #{uri}"
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.ca_file = Puppet[:localcacert]
    https.cert = OpenSSL::X509::Certificate.new File.read Puppet[:hostcert]
    https.key = OpenSSL::PKey::RSA.new File.read Puppet[:hostprivkey]

    request = Net::HTTP::Put.new uri.path
    request.body = File.read(_target_location_rds + ".bz2")
    request['Content-Type'] = 'text/xml'
    request['Content-Encoding'] = 'x-bzip2'
    begin
      res = https.request(request)
      res.value
    rescue StandardError => e
      self.info res.body
      raise Puppet::Error, "Upload failed: #{e.message}"
    end
  end

  def _upload_uri
    foreman_proxy_fqdn = Puppet[:server]
    foreman_proxy_port = 8443
    "https://#{foreman_proxy_fqdn}:#{foreman_proxy_port}/openscap/arf/#{resource[:name]}/#{_rds_date}"
  end

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
