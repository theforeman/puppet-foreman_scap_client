require 'spec_helper_acceptance'

describe 'foreman_scap_client' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
      class { 'foreman_scap_client':
        foreman_repo_rel => 'nightly',
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

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
      class { 'foreman_scap_client':
        foreman_repo_rel => 'nightly',
        server           => 'foreman.example.com',
        port             => 8443,
        policies         => [ { id: 1, profile_id: 'default', content_path: '/usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml' } ],
        obsolete         => false,
      }
      PUPPET
    end
  end

  describe package('rubygem-foreman_scap_client_bash') do
    it { is_expected.to be_installed }
  end
end
