class hive_meta {
  require hive_client
  require hive_db

  package { 'hive-metastore':
    ensure => installed,
  }
  ->
  service { 'hive-metastore':
    ensure => running,
    enable => true,
  }
}