# Private class.
class inam::service {
  assert_private()

  service { 'osu-inamd':
    ensure     => $::inam::service_ensure,
    enable     => $::inam::service_enable,
    name       => $::inam::service_name,
    hasstatus  => $::inam::service_hasstatus,
    hasrestart => $::inam::service_hasrestart,
  }
  -> service { 'osu-inamweb':
    ensure     => $::inam::web_service_ensure,
    enable     => $::inam::web_service_enable,
    name       => $::inam::web_service_name,
    hasstatus  => $::inam::web_service_hasstatus,
    hasrestart => $::inam::web_service_hasrestart,
  }

}
