require 'spec_helper'

describe 'play' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "play class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('play::params') }
        it { should contain_class('play::install').that_comes_before('play::config') }
        it { should contain_class('play::config') }
        it { should contain_class('play::service').that_subscribes_to('play::config') }

        it { should contain_service('play') }
        it { should contain_package('play').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'play class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('play') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
