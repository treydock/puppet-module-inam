# Private class.
class inam::install {
  assert_private()

  class { '::java':
    package => 'java-1.8.0-openjdk',
  }
  contain ::java

  contain ::mysql::bindings
  contain ::mysql::bindings::daemon_dev

  ::yum::install { 'osu-inam':
    ensure => 'present',
    source => $::inam::source_url,
  }

}
