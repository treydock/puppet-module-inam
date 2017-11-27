# Private class.
class inam::database (
  String $database_name = 'osuinamdb',
  String $database_user = 'osuinamuser',
  String $database_password = 'osuinampassword',
  String $database_host = 'localhost',
) {

  include ::mysql::server

  mysql::db { $::inam::database_name:
    ensure   => 'present',
    user     => $::inam::database_user,
    password => $::inam::database_password,
    host     => $::inam::database_host,
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
    grant    => ['ALL'],
  }
}