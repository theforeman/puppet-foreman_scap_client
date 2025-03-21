require 'spec_helper_acceptance'

describe 'foreman_scap_client' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
      class { 'foreman_scap_client':
        # Since 3.14 the Ruby implementation is replaced by bash
        foreman_repo_rel => '3.13',
        server           => 'foreman.example.com',
        port             => 8443,
        policies         => [],
      }
      PUPPET
    end
  end

  describe package('rubygem-foreman_scap_client') do
    it { is_expected.to be_installed }
  end
end
