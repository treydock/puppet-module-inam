# Private class.
class inam::params {

  case $::osfamily {
    'RedHat': {
      $source_url        = "http://mvapich.cse.ohio-state.edu/download/mvapich/inam/osu-inam-0.9.2.el${::operatingsystemmajrelease}.tar.gz"
      $service_name       = 'inam'
      $service_hasstatus  = true
      $service_hasrestart = true
      $config_path        = '/etc/inam.conf'
      if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
        $package_name_suffix = "-1.el${::operatingsystemmajrelease}.centos.x86_64.rpm"
        $tomcat_package      = 'tomcat'
        $tomcat_service      = 'tomcat'
        $catalina_home       = '/usr/share/tomcat'
      } else {
        $package_name_suffix = "-1.el${::operatingsystemmajrelease}.x86_64.rpm"
        $tomcat_package      = 'tomcat6'
        $tomcat_service      = 'tomcat6'
        $catalina_home       = '/usr/share/tomcat6'
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
