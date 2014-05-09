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

class hadoop_base {
  require repos_setup
  require jdk

  $log_dir="/var/log/hadoop"
  $data_dir="/var/run/hadoop"
  $pid_dir="/var/run/pid"
  $java="/usr/java/default"
  $keytab_dir="/etc/security/hadoop"
  $path="${java}/bin:/bin:/usr/bin"

  group { 'hadoop':
    ensure => present,
  }
  ->
  group { 'mapred':
    ensure => present,
  } 
  ->
  user { 'hdfs':
    ensure => present,
    gid => hadoop,
  }
  ->
  user { 'mapred':
    ensure => present,
    groups => ['mapred'],
    gid => hadoop,
  } 
  ->
  user { 'hive':
    ensure => present,
    gid => hadoop,
  }
  user { 'hcat':
    ensure => present,
    gid => hadoop,
  }
  ->
  Package['hadoop']


  package { 'hadoop':
    ensure => installed,
  }

  package { 'hadoop-pipes':
    ensure => installed,
    require => Package['hadoop'],
  }

  package { 'hadoop-native':
    ensure => installed,
    require => Package['hadoop'],
  }

  package { 'hadoop-libhdfs':
    ensure => installed,
    require => Package['hadoop'],
  }

  package { 'hadoop-lzo':
    ensure => installed,
    require => Package['hadoop'],
  }

  package { 'hadoop-lzo-native':
    ensure => installed,
    require => Package['hadoop'],
  }

  package { 'openssl':
    ensure => installed,
  }

  package { 'snappy':
    ensure => installed,
  }

  package { 'lzo':
    ensure => installed,
  }

  file { '/etc/hadoop':
    ensure => 'directory',
  }

  file { '/etc/hadoop/default':
    ensure => 'directory',
  }

  file { '/etc/hadoop/conf':
    ensure => 'link',
    target => '/etc/hadoop/default',
    require => Package['hadoop'],
  }

  file {'/usr/lib/hadoop/lib/native/Linux-amd64-64/libsnappy.so':
    ensure => 'link',
    target => '/usr/lib64/libsnappy.so.1',
    require => Package['hadoop-native'],
  }

  file { '/etc/hadoop/default/capacity-scheduler.xml':
    ensure => file,
    content => template('hadoop_base/capacity-scheduler.erb'),
  }

  file { '/etc/hadoop/default/commons-logging.properties':
    ensure => file,
    content => template('hadoop_base/commons-logging.erb'),
  }

  file { '/etc/hadoop/default/configuration.xsl':
    ensure => file,
    content => template('hadoop_base/configuration.erb'),
  }

  file { '/etc/hadoop/default/core-site.xml':
    ensure => file,
    content => template('hadoop_base/core-site.erb'),
  }

  file { '/etc/hadoop/default/dfs.exclude':
    ensure => file,
    content => "",
  }

  file { '/etc/hadoop/default/hadoop-env.sh':
    ensure => file,
    content => template('hadoop_base/hadoop-env.erb'),
  }

  file { '/etc/hadoop/default/hadoop-metrics2.properties':
    ensure => file,
    content => template('hadoop_base/hadoop-metrics2.erb'),
  }

  file { '/etc/hadoop/default/hadoop-policy.xml':
    ensure => file,
    content => template('hadoop_base/hadoop-policy.erb'),
  }

  file { '/etc/hadoop/default/hdfs-site.xml':
    ensure => file,
    content => template('hadoop_base/hdfs-site.erb'),
  }

  file { '/etc/hadoop/default/log4j.properties':
    ensure => file,
    content => template('hadoop_base/log4j.erb'),
  }

  file { '/etc/hadoop/default/mapred-env.sh':
    ensure => file,
    content => template('hadoop_base/mapred-env.erb'),
  }

  file { '/etc/hadoop/default/mapred-site.xml':
    ensure => file,
    content => template('hadoop_base/mapred-site.erb'),
  }

  file { '/etc/hadoop/default/task-log4j.properties':
    ensure => file,
    content => template('hadoop_base/task-log4j.erb'),
  }

  file { '/etc/hadoop/default/yarn.exclude':
    ensure => file,
    content => "",
  }

  file { "${data_dir}":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { "${data_dir}/hdfs":
    ensure => directory,
    owner => 'hdfs',
    group => 'hadoop',
    mode => '700',
  }

  file { "${data_dir}/mapred":
    ensure => directory,
    owner => 'mapred',
    group => 'hadoop',
    mode => '755',
  }

  file { "${pid_dir}":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { "${pid_dir}/hdfs":
    ensure => directory,
    owner => 'hdfs',
    group => 'hadoop',
    mode => '700',
  }

  file { "${pid_dir}/mapred":
    ensure => directory,
    owner => 'mapred',
    group => 'hadoop',
    mode => '700',
  }

  file { "${log_dir}":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { "${log_dir}/hdfs":
    ensure => directory,
    owner => 'hdfs',
    group => 'hadoop',
    mode => '700',
  }

  file { "${log_dir}/mapred":
    ensure => directory,
    owner => 'mapred',
    group => 'hadoop',
    mode => '755',
  }

  if $security == "true" {
    require kerberos_client
    require ssl_ca

    # bless the generated ca cert for java clients
    exec {"keytool -importcert -noprompt -alias horton-ca -keystore ${java}/jre/lib/security/cacerts -storepass changeit -file ca.crt":
      cwd => "/vagrant/generated/ssl-ca",
      path => "$path",
    }

    file {"/etc/hadoop/default/ssl-client.xml":
      ensure => file,
      content => template("hadoop_base/ssl-client.erb"),
    }
  }

}