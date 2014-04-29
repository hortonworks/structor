# This module create a generated certificate authority that can be used to 
# make certificates for all of the servers.
class ssl_ca {
  require jdk

  $java="/usr/java/default"
  $path="${java}/bin:/bin:/usr/bin"
  $cadir="/vagrant/generated/ssl-ca"

  file { "${cadir}":
    ensure => directory,
  }
  ->
  exec {'openssl genrsa -out ca.key 4096':
    cwd    => "${cadir}",
    creates => "${cadir}/ca.key",
    path => "$path",
  }
  ->
  exec {"openssl req -new -x509 -days 36525 -key ca.key -out ca.crt < /vagrant/modules/ssl_ca/files/ca-info.txt":
    cwd => "$cadir",
    creates => "${cadir}/ca.crt",
    path => "$path",
  }

  file {"${cadir}/ca.srl":
    replace => no,
    ensure => present,
    content => "01",
    mode => "600",
  }
}