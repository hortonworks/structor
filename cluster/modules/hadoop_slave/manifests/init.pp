class hadoop_slave {
  require hadoop_base

  if $security == "true" {
    require kerberos_http

    file { "/etc/security/hadoop/dn.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/dn.keytab",
      owner => hdfs,
      group => hadoop,
      mode => '400',
    }
    ->
    Package['hadoop-sbin']
    ->
    Package['hadoop-datanode']

    file { "/etc/security/hadoop/tt.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/tt.keytab",
      owner => mapred,
      group => hadoop,
      mode => '400',
    }
    ->
    package { "hadoop-sbin":
      ensure => installed,
    }
    ->
    file { "/etc/hadoop/default/taskcontroller.cfg":
      ensure => file,
      content => template('hadoop_slave/taskcontroller.erb'),
      owner => root,
      group => mapred,
      mode => 400,
    }
    ->
    Package['hadoop-tasktracker']
  }

  package { "hadoop-datanode" :
    ensure => installed,
  }
  ->
  service {"hadoop-datanode":
    ensure => running,
    enable => true,
  }

  package { "hadoop-tasktracker" :
    ensure => installed,
  }
  ->
  service {"hadoop-tasktracker":
    ensure => running,
    enable => true,
  }

}