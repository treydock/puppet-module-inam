require 'spec_helper_acceptance'

describe 'inam class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'inam':
        service_ensure => 'stopped',
        inamd_configs => {
          'OSU_INAM_ENABLE_HCA_NODES' => '1',
        }
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('osu-inam') do
      it { should be_installed }
    end

    describe service('osu-inamd') do
      it { should be_enabled }
      it { should_not be_running }
    end

    describe service('osu-inamweb') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
