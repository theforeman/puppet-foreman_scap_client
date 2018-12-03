require 'spec_helper'

describe 'foreman_scap_client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts}
    end

    context 'with minimal parameters' do
      let(:params) do
        {
          server: 'foreman-proxy.example.com',
          port: 8443,
          policies: {},
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
