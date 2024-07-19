require 'spec_helper'

describe 'foreman_scap_client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts}

      context 'with minimal parameters' do
        let(:params) do
          {
            server: 'foreman-proxy.example.com',
            port: 8443,
            policies: [],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('foreman_scap_client')
            .with_path('/etc/foreman_scap_client/config.yaml')
            .with_content(%r{^:ca_file: '/etc/puppetlabs/puppet/ssl/certs/ca\.pem'$})
            .with_content(%r{^:host_certificate: '/etc/puppetlabs/puppet/ssl/certs/[a-z0-9\-\.]+.pem'$})
            .with_content(%r{^:host_private_key: '/etc/puppetlabs/puppet/ssl/private_keys/[a-z0-9\-\.]+.pem'$})
        end

        context 'with rh certificates' do
          let(:facts) do
            super().merge(rh_certificate: {
              repo_ca_cert: '/etc/rhsm/ca/redhat-uep.pem',
              consumer_host_cert: '/etc/rhsm/host/cert.pem',
              consumer_host_key: '/etc/rhsm/host/key.pem',
            })
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('foreman_scap_client')
              .with_path('/etc/foreman_scap_client/config.yaml')
              .with_content(%r{^:ca_file: '/etc/rhsm/ca/redhat-uep\.pem'$})
              .with_content(%r{^:host_certificate: '/etc/rhsm/host/cert\.pem'$})
              .with_content(%r{^:host_private_key: '/etc/rhsm/host/key\.pem'$})
          end
        end

        context 'with flag to install bash version' do
          let(:params) do
            super().merge({
              obsolete: false,
              policies: [
                {
                  id: 1,
                  profile_id: 'default',
                  content_path: '/usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml',
                }
              ]
            })
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('foreman_scap_client')
              .with_path('/etc/foreman_scap_client/config')
              .with_content(%r{^POLICY_1_PROFILE="default"$})
              .with_content(%r{^POLICY_1_CONTENT_PATH="/usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml"$})
          end
        end
      end
    end
  end
end
