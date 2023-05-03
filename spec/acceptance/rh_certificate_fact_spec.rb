require 'spec_helper_acceptance'

describe 'rh_certificate fact' do
  before { default.install_package('subscription-manager') }

  let(:command) { on default, 'puppet facts show --value-only rh_certificate' }
  subject { command.success? ? JSON.load(command.output) : command }

  it { is_expected.to eq({'repo_ca_cert' => '/etc/rhsm/ca/redhat-uep.pem', 'consumer_host_cert' => '/etc/pki/consumer/cert.pem', 'consumer_host_key' => '/etc/pki/consumer/key.pem'}) }
end
