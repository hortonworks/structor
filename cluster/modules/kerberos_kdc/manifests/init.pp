class kerberos_kdc {
  require kerberos_client
  $path="/bin:/usr/bin:/sbin:/usr/sbin"
  $password="vagrant"

  package { 'krb5-server':
    ensure => installed,
  }
  ->
  file { '/var/kerberos/krb5kdc/kdc.conf':
    ensure => file,
    content => template('kerberos_kdc/kdc.erb'),
  }
  ->
  file { '/vagrant/generated':
    ensure => directory,
    mode => 'go-rwx',
  }
  ->
  file { '/vagrant/generated/create-kerberos-db':
    ensure => file,
    content => template('kerberos_kdc/create-kerberos-kdc.erb'),
    mode => 'u=rwx,go=',
  }
  ->
  exec { 'kdc-init':
    command => "/vagrant/generated/create-kerberos-db",
    creates => "/var/kerberos/krb5kdc/principal",
    path => $path,
  }
  ->
  service { 'krb5kdc':
    ensure => running,
    enable => true,
  }
}