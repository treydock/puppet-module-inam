# Private class.
class inam::service {
  assert_private()

  service { $::inam::params::tomcat_service:
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  if $::service_provider == 'systemd' {
    ::systemd::unit_file { 'osu-inamd.service':
      content => template('inam/systemd/osu-inamd.service.erb'),
      notify  => Service['osu-inamd'],
    }
    Exec['systemctl-daemon-reload'] -> Service['osu-inamd']

    service { 'osu-inamd':
      ensure     => $::inam::service_ensure,
      enable     => $::inam::service_enable,
      name       => $::inam::service_name,
      hasstatus  => $::inam::service_hasstatus,
      hasrestart => $::inam::service_hasrestart,
      before     => Service[$::inam::params::tomcat_service],
    }
  } else {
    service { 'osu-inamd':
      ensure     => $::inam::service_ensure,
      name       => $::inam::service_name,
      hasstatus  => false,
      hasrestart => false,
      start      => '/opt/osu-inam/bin/osu-inamd -c /opt/osu-inam/osu-inamd.conf -f /opt/osu-inam/osu-inam.conf -p /var/run/osu-inam.pid',
      stop       => 'pkill osu-inamd',
      provider   => 'base',
    }
  }

}
