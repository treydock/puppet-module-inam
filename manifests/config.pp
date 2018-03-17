# Private class.
class inam::config {
  assert_private()

  file { '/opt/osu-inam/phantomjs':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/osu-inam.properties':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
    before => [Augeas['/etc/osu-inam.properties'], Augeas['/etc/osu-inam.properties-password']],
  }

  augeas { '/etc/osu-inam.properties':
    lens    => 'Properties.lns',
    incl    => '/etc/osu-inam.properties',
    changes => [
      "set osuinam.counterinterval ${::inam::counterinterval}",
      "set osuinam.clustering_threshold ${::inam::clustering_threshold}",
      "set osuinam.clustername ${::inam::clustername}",
      "set osuinam.datasource.opensmurl ${::inam::opensmurl}",
      "set osuinam.datasource.username ${::inam::database_user}",
      "set osuinam.datasource.password ${::inam::database_password}",
      "set osuinam.datasource.initial-size ${::inam::datasource_initial_size}",
      "set osuinam.datasource.max-active ${::inam::datasource_max_active}",
      "set phantomjs.execdir ${::inam::phantomjs_execdir}",
      'set phantomjs.runjs /opt/osu-inam/lib/inam.js',
      'set phantomjs.filedir /opt/osu-inam/phantomjs/filedir',
      'set phantomjs.cachefile /opt/osu-inam/phantomjs/cachefile',
    ],
    notify  => Service['osu-inamweb'],
  }

  augeas { '/etc/osu-inam.properties-password':
    lens      => 'Properties.lns',
    incl      => '/etc/osu-inam.properties',
    changes   => [
      "set osuinam.datasource.password ${::inam::database_password}",
    ],
    show_diff => false,
    notify    => Service['osu-inamweb'],
  }

  file { '/opt/osu-inam/etc/osu-inamd.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
    before => [Augeas['/opt/osu-inam/etc/osu-inamd.conf'], Augeas['/opt/osu-inam/etc/osu-inamd.conf-password']],
  }

  $inamd_configs_changes = $::inam::inamd_configs.map |$key,$value| {
    "set ${key} ${value}"
  }
  $inamd_conf_defaults = [
    "set OSU_INAM_DATABASE_HOST ${::inam::database_host}",
    'set OSU_INAM_DATABASE_PORT 3306',
    "set OSU_INAM_DATABASE_NAME ${::inam::database_name}",
    "set OSU_INAM_DATABASE_USER ${::inam::database_user}",
  ]
  $inamd_conf_changes = $inamd_conf_defaults + $inamd_configs_changes

  augeas { '/opt/osu-inam/etc/osu-inamd.conf':
    lens    => 'Shellvars.lns',
    incl    => '/opt/osu-inam/etc/osu-inamd.conf',
    changes => $inamd_conf_changes,
    notify  => Service['osu-inamd'],
  }

  augeas { '/opt/osu-inam/etc/osu-inamd.conf-password':
    lens      => 'Shellvars.lns',
    incl      => '/opt/osu-inam/etc/osu-inamd.conf',
    changes   => [
      "set OSU_INAM_DATABASE_PASSWD ${::inam::database_password}",
    ],
    show_diff => false,
    notify    => Service['osu-inamd'],
  }

}
