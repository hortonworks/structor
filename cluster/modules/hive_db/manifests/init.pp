class hive_db {
  $PATH = "/bin:/usr/bin"

  package { 'mysql-server':
    ensure => installed,
  }
  ->
  service { 'mysqld':
    ensure => running,
    enable => true,
  }
  ->
  exec { "secure-mysqld":
    command => "mysql_secure_installation < files/secure-mysql.txt",
    path => "${PATH}",
    cwd => "/vagrant/modules/hive_db",
  }
  ->
  exec { "create-hivedb":
    command => "mysql -u root --password=vagrant < files/setup-hive.txt",
    path => "${PATH}",
    cwd => "/vagrant/modules/hive_db",
  }
}