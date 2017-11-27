# Private class.
class inam::install {
  assert_private()

  class { '::java':
    package => 'java-1.7.0-openjdk',
  }
  contain ::java

  $package_name = "osu-inam-${::inam::version}${::inam::package_name_suffix}"

  package { $::inam::params::tomcat_package:
    ensure => 'installed',
  }

  file { "/opt/osu-inam-${::inam::version}":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  -> archive { '/tmp/osu-inam.tar.gz':
    source          => $::inam::source_url,
    extract         => true,
    extract_path    => "/opt/osu-inam-${::inam::version}",
    extract_command => 'tar xfz %s --strip-components=1',
    creates         => "/opt/osu-inam-${::inam::version}/${package_name}",
    cleanup         => true,
    user            => 'root',
    group           => 'root',
  }
  -> ::yum::install { 'osu-inam':
    ensure => 'present',
    source => "/opt/osu-inam-${::inam::version}/${package_name}",
  }

}
