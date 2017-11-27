# Private class.
class inam::config {
  assert_private()

  file { "${::inam::params::catalina_home}/webapps/osu-inam.war":
    ensure => 'file',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0644',
    source => "/opt/osu-inam-${::inam::version}/osu-inam-${::inam::war_version}.war"
  }

  file { "${::inam::params::catalina_home}/conf/Catalina/localhost/osu-inam.xml":
    ensure => 'file',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0644',
    source => "/opt/osu-inam-${::inam::version}/osu-inam-${::inam::war_version}.xml"
  }


  file { '/opt/osu-inam/phantomjs':
    ensure => 'directory',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0755',
  }
  file { '/opt/osu-inam/phantomjs/inam.js':
    ensure => 'file',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0644',
    source => "/opt/osu-inam-${::inam::version}/inam.js"
  }
  file { '/opt/osu-inam/phantomjs/vis.js':
    ensure => 'file',
    owner  => 'tomcat',
    group  => 'tomcat',
    mode   => '0644',
    source => "/opt/osu-inam-${::inam::version}/vis.js"
  }

  file { '/etc/osu-inam.properties':
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0640',
    source  => "/opt/osu-inam-${::inam::version}/osu-inam.properties",
    replace => false,
    before  => Augeas['/etc/osu-inam.properties'],
  }

  augeas { '/etc/osu-inam.properties':
    lens    => 'Properties.lns',
    incl    => '/etc/osu-inam.properties',
    changes => [
      "set osuinam.counterinterval ${::inam::counterinterval}",
      "set osuinam.clustering_threshold ${::inam::clustering_threshold}",
      "set osuinam.datasource.opensmurl ${::inam::opensmurl}",
      "set osuinam.datasource.username ${::inam::database_user}",
      "set osuinam.datasource.password ${::inam::database_password}",
      "set osuinam.datasource.initialsize ${::inam::datasource_initialsize}",
      "set osuinam.datasource.maxIdle ${::inam::datasource_maxidle}",
      "set osuinam.datasource.maxtotal ${::inam::datasource_maxtotal}",
      "set osuinam.datasource.maxwaitmillis ${::inam::datasource_maxwaitmillis}",
      'set phantomjs.execdir /usr/local/bin',
      'set phantomjs.runjs /opt/osu-inam/phantomjs/inam.js',
      'set phantomjs.filedir /opt/osu-inam/phantomjs/filedir',
      'set phantomjs.cachefile /opt/osu-inam/phantomjs/cachefile',
    ],
    notify  => Service[$::inam::params::tomcat_service],
  }

  Shellvar {
    ensure => 'present',
    target => '/opt/osu-inam/osu-inamd.conf',
    notify => Service['osu-inamd'],
  }

  shellvar { 'OSU_INAM_DATABASE_HOST': value => $::inam::database_host }
  shellvar { 'OSU_INAM_DATABASE_PORT': value => 3306 }
  shellvar { 'OSU_INAM_DATABASE_NAME': value => $::inam::database_name }
  shellvar { 'OSU_INAM_DATABASE_USER': value => $::inam::database_user }
  shellvar { 'OSU_INAM_DATABASE_PASSWD': value => $::inam::database_password }

}
