class kerberos_client {
  require ntp


  package { 'krb5-auth-dialog':
    ensure => installed,
  }

  package { 'krb5-workstation':
    ensure => installed,
  }

  package { 'krb5-libs':
    ensure => installed,
  }
  ->
  file { '/etc/krb5.conf':
    ensure => file,
    content => template('kerberos_client/krb5.erb'),
  }
}