# See README.md for more details.
class inam (
  String $version        = '0.9.2',
  String $war_version    = '0.9.1',
  String $source_url           = $inam::params::source_url,
  String $package_name_suffix            = $inam::params::package_name_suffix,
  Optional[String] $package_repo = undef,
  # Database
  Boolean $database = true,
  String $database_name = 'osuinamdb',
  String $database_user = 'osuinamuser',
  String $database_password = 'osuinampassword',
  String $database_host = 'localhost',
  # Config
  Integer $counterinterval  = 30,
  Integer $clustering_threshold = 500,
  Integer $datasource_initialsize = 20,
  Integer $datasource_maxidle = 20,
  Integer $datasource_maxtotal = 50,
  Integer $datasource_maxwaitmillis = 10000,
  # Service
  String $service_name          = 'osu-inamd',
  String $service_ensure        = 'running',
  Boolean $service_enable       = true,
  Boolean $service_hasstatus    = true,
  Boolean $service_hasrestart   = true,
) inherits inam::params {

  $opensmurl = "jdbc:mysql://${database_host}:3306/${database_name}"

  contain ::phantomjs
  contain inam::install
  contain inam::config
  contain inam::service

  Class['::phantomjs']
  -> Class['inam::install']
  -> Class['inam::config']
  -> Class['inam::service']

  if $database {
    class { '::inam::database':
      database_name     => $database_name,
      database_user     => $database_user,
      database_password => $database_password,
      database_host     => $database_host,
    }

    Class['inam::install'] -> Class['inam::database']
    Class['inam::database'] -> Class['inam::config']
  }

}
