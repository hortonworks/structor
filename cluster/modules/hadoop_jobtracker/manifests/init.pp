class hadoop_jobtracker {
  require hadoop_base

  $PATH = "/bin:/usr/bin"

  package { "hadoop-jobtracker" :
    ensure => installed,
  }
  ->
  service {"hadoop-jobtracker":
    ensure => running,
    enable => true,
  }
}