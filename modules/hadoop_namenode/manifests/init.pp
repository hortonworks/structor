#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

class hadoop_namenode {
  require hadoop_base

  $PATH="/bin:/usr/bin"

  if $security == "true" {
    require kerberos_http
    file { "/etc/security/hadoop/nn.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/nn.keytab",
      owner => hdfs,
      group => hadoop,
      mode => '400',
    }
    ->
    exec { "kinit -k -t /etc/security/hadoop/nn.keytab nn/${hostname}.${domain}":
      path => $PATH,
      user => hdfs,
    }
    ->
    Package['hadoop-namenode']
  }

  package { "hadoop-namenode" :
    ensure => installed,
  }
  ->
  exec {"namenode-format":
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
  ->
  exec {"hive-warehouse":
    command => "hadoop fs -mkdir /apps/hive/warehouse",
    unless => "hadoop fs -test -e /apps/hive/warehouse",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hive-warehouse-chmod":
    command => "hadoop fs -chmod 777 /apps/hive/warehouse",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hdfs-tmp":
    command => "hadoop fs -mkdir /tmp",
    unless => "hadoop fs -test -e /tmp",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hdfs-tmp-chmod":
    command => "hadoop fs -chmod 777 /tmp",
    path => "$PATH",
    user => "hdfs",
  }
}