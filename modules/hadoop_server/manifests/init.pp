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

# This class creates the various hadoop users and the log and pid directories 
# that are required for hdfs and yarn servers.
class hadoop_server {
  require hdfs_client
  require yarn_client

  $path="/bin:/usr/bin"

  group { 'hadoop':
    ensure => present,
  }
  ->
  group { 'mapred':
    ensure => present,
  }
  ->
  group { 'yarn':
    ensure => present,
  }
  ->
  group { 'oozie':
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
  user { 'yarn':
    ensure => present,
    groups => ['yarn', 'mapred'],
    gid => hadoop,
  } 
  ->
  user { 'hive':
    ensure => present,
    gid => hadoop,
  }
  ->
  user { 'oozie':
    ensure => present,
    groups => ['hadoop'],
    gid => 'oozie',
  }
  ->
  user { 'hbase':
    ensure => present,
    gid => 'hadoop',
  }

  file { "${hdfs_client::data_dir}":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { "${hdfs_client::data_dir}/hdfs":
    ensure => directory,
    owner => 'hdfs',
    group => 'hadoop',
    mode => '700',
  }

  file { "${hdfs_client::data_dir}/yarn":
    ensure => directory,
    owner => 'yarn',
    group => 'hadoop',
    mode => '755',
  }

  file { "${hdfs_client::pid_dir}":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { "${hdfs_client::pid_dir}/hdfs":
    ensure => directory,
    owner => 'hdfs',
    group => 'hadoop',
    mode => '700',
  }

  file { "${hdfs_client::pid_dir}/mapred":
    ensure => directory,
    owner => 'mapred',
    group => 'hadoop',
    mode => '700',
  }

  file { "${hdfs_client::pid_dir}/yarn":
    ensure => directory,
    owner => 'yarn',
    group => 'hadoop',
    mode => '700',
  }

  file { "${hdfs_client::log_dir}":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { "${hdfs_client::log_dir}/hdfs":
    ensure => directory,
    owner => 'hdfs',
    group => 'hadoop',
    mode => '700',
  }

  file { "${hdfs_client::log_dir}/mapred":
    ensure => directory,
    owner => 'mapred',
    group => 'hadoop',
    mode => '755',
  }

  file { "${hdfs_client::log_dir}/yarn":
    ensure => directory,
    owner => 'yarn',
    group => 'hadoop',
    mode => '755',
  }

  file { "${hdfs_client::log_dir}/hbase":
    ensure => directory,
    owner => 'hbase',
    group => 'hadoop',
    mode => '755',
  }

  file { "${hdfs_client::pid_dir}/hbase":
    ensure => directory,
    owner => 'hbase',
    group => 'hadoop',
    mode => '755',
  }
}