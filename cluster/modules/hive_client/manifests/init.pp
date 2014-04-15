class hive_client {
  require hadoop_base

  package { 'hive':
    ensure => installed,
  }

  package { 'hcatalog':
    ensure => installed,
  }

  file { '/etc/hive':
    ensure => 'directory',
  }

  file { '/etc/hive/default':
    ensure => 'directory',
  }

  file { '/etc/hive/conf':
    ensure => 'link',
    target => '/etc/hive/default',
    require => Package['hive'],
  }

  file { '/etc/hive/default/hive-env.sh':
    ensure => file,
    content => template('hive_client/hive-env.erb'),
  }

  file { '/etc/hive/default/hive-site.xml':
    ensure => file,
    content => template('hive_client/hive-site.erb'),
  }

  file { '/etc/hive/default/hive-log4j.properties':
    ensure => file,
    content => template('hive_client/hive-log4j.erb'),
  }

  package { 'mysql-connector-java':
    ensure => installed,
  }

  file { '/usr/lib/hive/lib/mysql-connector-java.jar':
    ensure => 'link',
    target => '/usr/share/java/mysql-connector-java.jar',
    require => Package['hive'],
  }
}