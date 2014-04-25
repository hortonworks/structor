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
  exec { 'kdc-init':
    command => "kdb5_util create -s -P '$password'",
    creates => "/var/kerberos/krb5kdc/principal",
    path => $path,
  }
  ->
  service { 'krb5kdc':
    ensure => running,
    enable => true,
  }
}