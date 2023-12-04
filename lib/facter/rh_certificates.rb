Facter.add('rh_certificate') do
  confine kernel: 'Linux'
  setcode do
    data = Facter::Util::Resolution.exec('/usr/sbin/subscription-manager config')
    break if data.nil? || data.empty?
    data_hash = data.gsub(/[\n\[\]]/, "").scan(/(\S+)\s*=\s* ([^ ]+)/).to_h
    consumer_cert_dir = data_hash["consumercertdir"]
    {
      repo_ca_cert: data_hash["repo_ca_cert"],
      consumer_host_cert: File.join(consumer_cert_dir, 'cert.pem'),
      consumer_host_key: File.join(consumer_cert_dir, 'key.pem'),
    }
  end
end
