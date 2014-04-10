class hadoop_namenode {
  require hadoop_base

  $PATH="/bin:/usr/bin"

  package { "hadoop-namenode" :
    ensure => installed,
  }

  exec {"format":
    command => "hadoop namenode -format",
    path => "$PATH",
    creates => "${data_dir}/hdfs/nn",
    user => "hdfs",
    require => Package['hadoop-namenode'],
  }
  ->
  service {"hadoop-namenode":
    ensure => running,
    enable => true,
  }
  ->
  exec {"mapred-home-mkdir":
    command => "hadoop fs -mkdir /user/mapred",
    unless => "hadoop fs -test -e /user/mapred",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"mapred-home-chown":
    command => "hadoop fs -chown mapred:mapred /user/mapred",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"vagrant-home-mkdir":
    command => "hadoop fs -mkdir /user/vagrant",
    unless => "hadoop fs -test -e /user/vagrant",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"vagrant-home-chown":
    command => "hadoop fs -chown vagrant:vagrant /user/vagrant",
    path => "$PATH",
    user => "hdfs",
  }
}