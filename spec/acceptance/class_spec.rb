require 'spec_helper_acceptance'

describe 'inam class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'inam':
        service_ensure => 'stopped',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('osu-inam') do
      it { should be_installed }
    end

    if fact('operatingsystemrelease') =~ /^7/
      describe service('osu-inamd') do
        it { should be_enabled }
        it { should_not be_running }
      end
    end
  end
end
