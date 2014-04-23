class hive_meta {
  require hive_client
  require hive_db

  package { 'hive-metastore':
    ensure => installed,
  }
  ->
  file { '/etc/init.d/hive-metastore':
    ensure => file,
    content => template('hive_meta/hive-metastore.erb'),
    mode => 'a+rx',
  }
  ->
  service { 'hive-metastore':
    ensure => running,
    enable => true,
  }
}