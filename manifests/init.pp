# See README.md for more details.
class inam (
  Variant[Stdlib::HTTPSUrl,Stdlib::HTTPUrl]
    $source_url                                     = $inam::params::source_url,
  # Database
  Boolean $database                                 = true,
  String $database_name                             = 'osuinamdb',
  String $database_user                             = 'osuinamuser',
  String $database_password                         = 'osuinampassword',
  String $database_host                             = 'localhost',
  # Config
  Integer $counterinterval                          = 30,
  Integer $clustering_threshold                     = 500,
  String $clustername                               = 'osuinamcluster',
  Integer $datasource_initial_size                  = 20,
  Integer $datasource_max_active                    = 50,
  Hash $inamd_configs                               = {},
  Stdlib::Filemode $config_mode                     = '0640',
  Optional[Stdlib::Absolutepath] $phantomjs_execdir = undef,
  # Service
  String $service_name                              = 'osu-inamd',
  String $service_ensure                            = 'running',
  Boolean $service_enable                           = true,
  Boolean $service_hasstatus                        = $inam::params::service_hasstatus,
  Boolean $service_hasrestart                       = true,
  String $web_service_name                          = 'osu-inamweb',
  String $web_service_ensure                        = 'running',
  Boolean $web_service_enable                       = true,
  Boolean $web_service_hasstatus                    = true,
  Boolean $web_service_hasrestart                   = true,
  # Apache
  Boolean $manage_apache                            = true,
  Boolean $apache_ssl                               = false,
  String $apache_servername                         = $::fqdn,
  Optional[Stdlib::Absolutepath] $apache_ssl_cert   = undef,
  Optional[Stdlib::Absolutepath] $apache_ssl_key    = undef,
  Optional[Stdlib::Absolutepath] $apache_ssl_chain  = undef,
) inherits inam::params {

  $opensmurl = "jdbc:mysql://${database_host}:3306/${database_name}"

  contain ::phantomjs
  $_phantomjs_execdir = pick($phantomjs_execdir, dirname($::phantomjs::path))

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

  if $manage_apache {
    contain inam::apache
    Class['inam::service'] -> Class['inam::apache']
  }

}
