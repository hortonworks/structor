class hadoop_slave {
  require hadoop_base

  package { "hadoop-datanode" :
    ensure => installed,
  }

  package { "hadoop-tasktracker" :
    ensure => installed,
  }

  service {"hadoop-datanode":
    ensure => running,
    enable => true,
  }

  service {"hadoop-tasktracker":
    ensure => running,
    enable => true,
  }
}