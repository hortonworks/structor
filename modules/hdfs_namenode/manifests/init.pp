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

class hdfs_namenode {
  require hdfs_client
  require hadoop_server

  $PATH="/bin:/usr/bin"

  if $security == "true" {
    require kerberos_http
    file { "${hdfs_client::keytab_dir}/nn.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/nn.keytab",
      owner => hdfs,
      group => hadoop,
      mode => '400',
    }
    ->
    exec { "kinit -k -t ${hdfs_client::keytab_dir}/nn.keytab nn/${hostname}.${domain}":
      path => $PATH,
      user => hdfs,
    }
    ->
    Package['hadoop-hdfs-namenode']
  }

  package { "hadoop-hdfs-namenode" :
    ensure => installed,
  }
  ->
  file { "/etc/init.d/hadoop-hdfs-namenode":
    ensure => file,
    source => "puppet:///files/init.d/hadoop-hdfs-namenode",
    owner => root,
    group => root,
  }
  ->
  exec {"namenode-format":
    command => "hadoop namenode -format",
    path => "$PATH",
    creates => "${hdfs_client::data_dir}/hdfs/namenode",
    user => "hdfs",
    require => Package['hadoop-hdfs-namenode'],
  }
  ->
  service {"hadoop-hdfs-namenode":
    ensure => running,
    enable => true,
  }
  ->
  exec {"yarn-home-mkdir":
    command => "hadoop fs -mkdir -p /user/yarn",
    unless => "hadoop fs -test -e /user/yarn",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-home-chown":
    command => "hadoop fs -chown yarn:yarn /user/yarn",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-home-chmod":
    command => "hadoop fs -chmod 755 /user/yarn",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-history-mkdir":
    command => "hadoop fs -mkdir -p /user/yarn/history",
    unless => "hadoop fs -test -e /user/yarn/history",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-history-chmod":
    command => "hadoop fs -chmod 775 /user/yarn/history",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-history-chown":
    command => "hadoop fs -chown -R mapred:mapred /user/yarn/history",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-app-logs-mkdir":
    command => "hadoop fs -mkdir /user/yarn/app-logs",
    unless => "hadoop fs -test -e /user/yarn/app-logs",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-app-logs-chmod":
    command => "hadoop fs -chmod 1777 /user/yarn/app-logs",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"yarn-app-logs-chown":
    command => "hadoop fs -chown yarn:mapred /user/yarn/app-logs",
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
    command => "hadoop fs -mkdir -p /apps/hive/warehouse",
    unless => "hadoop fs -test -e /apps/hive/warehouse",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hive-warehouse-chown":
    command => "hadoop fs -chown hive:hive /apps/hive/warehouse",
    path => "$PATH",
    user => "hdfs",
  }
  ->
  exec {"hive-warehouse-chmod":
    command => "hadoop fs -chmod 1777 /apps/hive/warehouse",
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
    command => "hadoop fs -chmod 1777 /tmp",
    path => "$PATH",
    user => "hdfs",
  }
}