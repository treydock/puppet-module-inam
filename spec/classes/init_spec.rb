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

      case facts[:operatingsystemrelease]
      when /^7/
        package_name = "osu-inam-0.9.2-1.el7.centos.x86_64.rpm"
        tomcat_package = 'tomcat'
        tomcat_service = 'tomcat'
      when /^6/
        package_name = "osu-inam-0.9.2-1.el6.x86_64.rpm"
        tomcat_package = 'tomcat6'
        tomcat_service = 'tomcat6'
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('inam') }
      it { is_expected.to contain_class('inam::params') }

      it { is_expected.to contain_class('inam::install').that_comes_before('Class[inam::config]') }
      it { is_expected.to contain_class('inam::config').that_comes_before('Class[inam::service]') }
      it { is_expected.to contain_class('inam::service') }

      context "inam::install" do
        it do
          is_expected.to contain_package(tomcat_package).with({
            :ensure => 'installed',
          })
        end
        it do
          is_expected.to contain_yum__install('osu-inam').only_with({
            :ensure => 'present',
            :source => "/opt/osu-inam-0.9.2/#{package_name}",
          })
        end
      end

      context "inam::config" do
        
      end

      context "inam::service" do
        it do
          is_expected.to contain_service(tomcat_service).with({
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
