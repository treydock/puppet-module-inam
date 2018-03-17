require 'spec_helper'

describe 'inam' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/dne',
        })
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('inam') }
      it { is_expected.to contain_class('inam::params') }

      it { is_expected.to contain_class('inam::install').that_comes_before('Class[inam::config]') }
      it { is_expected.to contain_class('inam::config').that_comes_before('Class[inam::service]') }
      it { is_expected.to contain_class('inam::service') }

      context "inam::install" do
        it do
          is_expected.to contain_yum__install('osu-inam').only_with({
            :ensure => 'present',
            :source => "http://mvapich.cse.ohio-state.edu/download/mvapich/inam/osu-inam-0.9.3-1.el#{facts[:operatingsystemmajrelease]}.x86_64.rpm",
          })
        end
      end

      context "inam::config" do
        
      end

      context "inam::service" do
        it do
          is_expected.to contain_service('osu-inamd').with({
            :ensure      => 'running',
            :enable      => 'true',
            :hasstatus   => 'true',
            :hasrestart  => 'true',
          })
        end
        it do
          is_expected.to contain_service('osu-inamweb').with({
            :ensure      => 'running',
            :enable      => 'true',
            :hasstatus   => 'true',
            :hasrestart  => 'true',
          })
        end
      end

    end # end context
  end # end on_supported_os loop
end # end describe
