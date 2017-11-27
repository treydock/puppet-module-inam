#
class inam::apache {
  assert_private()

  include ::apache

  if $::inam::apache_ssl {
    $port = 443
    ::apache::vhost { 'osu-inam-redirect':
      servername      => $::inam::apache_servername,
      port            => 80,
      redirect_status => 'permanent',
      redirect_dest   => "https://${::inam::apache_servername}/",
      docroot         => '/opt/osu-inam',
      manage_docroot  => false,
    }
  } else {
    $port = 80
  }

  ::apache::vhost { 'osu-inam':
    servername          => $::inam::apache_servername,
    port                => $port,
    ssl                 => $::inam::apache_ssl,
    proxy_preserve_host => true,
    proxy_pass          => [
      {'path' => '/', 'url' => 'http://localhost:8080'},
    ],
    ssl_cert            => $::inam::apache_ssl_cert,
    ssl_key             => $::inam::apache_ssl_key,
    ssl_chain           => $::inam::apache_ssl_chain,
    docroot             => '/opt/osu-inam',
    manage_docroot      => false,
  }

}
