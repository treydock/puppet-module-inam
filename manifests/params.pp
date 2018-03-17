# Private class.
class inam::params {

  case $::osfamily {
    'RedHat': {
      $source_url = "http://mvapich.cse.ohio-state.edu/download/mvapich/inam/osu-inam-0.9.3-1.el${::operatingsystemmajrelease}.x86_64.rpm"
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
