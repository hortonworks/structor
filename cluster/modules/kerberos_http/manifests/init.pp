class kerberos_http {

  require hadoop_base
  require kerberos_client
  require ssl_ca

  if hasrole($roles, 'kdc') {
    Class['kerberos_kdc'] -> Class['kerberos_http']
  }

  $java = "/usr/java/default"
  $path = "${java}/bin:/bin:/usr/bin"

  file { "/etc/security/hadoop":
    ensure => directory,
    owner => 'root',
    group => 'hadoop',
    mode => '750',
  }
  ->
  file { "/etc/security/hadoop/http-secret":
    ensure => file,
    # this needs to be a cluster wide secret
    content => vagrant,
    owner => root,
    group => hadoop,
    mode => 440,
  }
  ->
  file { "/etc/security/hadoop/http.keytab":
    ensure => file,
    source => "/vagrant/generated/keytabs/${hostname}/HTTP.keytab",
    owner => 'root',
    group => 'hadoop',
    mode => '440',
  }
  ->
  file { "/tmp/create-cert":
    ensure => file,
    content => template('kerberos_http/create-cert.erb'),
    mode => '700',
  }
  ->
  exec { '/tmp/create-cert':
    creates => '/etc/security/hadoop/server.crt',
    cwd => '/etc/security/hadoop',
    path => '$path',
    provider => shell,
  }
  
  file { '/etc/hadoop/default/ssl-server.xml':
    ensure => file,
    owner => 'root',
    group => 'hadoop',
    mode => '640',
    content => template('kerberos_http/ssl-server.erb'),
  }
}