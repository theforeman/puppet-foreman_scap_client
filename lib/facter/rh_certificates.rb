def extract_certificates_from_subscription_manager
  certificates = {}
  certificate_end_path = '/cert.pem'
  private_key_end_path = '/key.pem'
  rh_default_ca_cert = '/etc/rhsm/ca/redhat-uep.pem'
  data = Facter::Util::Resolution.exec('/usr/sbin/subscription-manager config')
  return nil if data.nil? || data.empty?
  data = data.gsub("\n", "").gsub(/[\[\]]/, "")
  data_array = data.scan(/(\S+)\s*=\s* ([^ ]+)/)
  data_hash = Hash[*data_array.flatten]
  consumer_cert_dir = data_hash["consumercertdir"]
  certificates[:repo_ca_cert]          = data_hash["repo_ca_cert"] unless data_hash["repo_ca_cert"] == rh_default_ca_cert
  certificates[:host_certificate_path] = consumer_cert_dir + certificate_end_path
  certificates[:host_private_key_path] = consumer_cert_dir + private_key_end_path

  certificates
end

certificates_hash = extract_certificates_from_subscription_manager
# Set Katello certificates only if certificates_hash[:repo_ca_cert] exists
if certificates_hash && certificates_hash[:repo_ca_cert]
  Facter.add('rh_certificate_repo_ca_file') do
    setcode do
      certificates_hash[:repo_ca_cert]
    end
  end

  Facter.add('rh_certificate_consumer_host_cert') do
    setcode do
      certificates_hash[:host_certificate_path]
    end
  end

  Facter.add('rh_certificate_consumer_host_key') do
    setcode do
      certificates_hash[:host_private_key_path]
    end
  end
end
