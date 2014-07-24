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

Puppet::Type.type(:scap_upload).provide :foreman_proxy do

  def upload(xccdf_eval)
    uri = URI.parse(_upload_uri xccdf_eval)
    self.info "Uploading results to #{uri}"
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.ca_file = Puppet[:localcacert]
    https.cert = OpenSSL::X509::Certificate.new File.read Puppet[:hostcert]
    https.key = OpenSSL::PKey::RSA.new File.read Puppet[:hostprivkey]

    request = Net::HTTP::Put.new uri.path
    request.body = File.read(xccdf_eval.result_path)
    request['Content-Type'] = 'text/xml'
    request['Content-Encoding'] = 'x-bzip2'
    begin
      res = https.request(request)
      res.value
    rescue StandardError => e
      self.info res.body if res
      raise Puppet::Error, "Upload failed: #{e.message}"
    end
  end

  private

  def _upload_uri xccdf_eval
    _foreman_proxy_uri + "/openscap/arf/#{xccdf_eval.policy_name}/#{xccdf_eval.date}"
  end

  def _foreman_proxy_uri
    return resource[:foreman_proxy] unless resource[:foreman_proxy] == ''
    foreman_proxy_fqdn = Puppet[:server]
    foreman_proxy_port = 8443
    "https://#{foreman_proxy_fqdn}:#{foreman_proxy_port}"
  end

end

