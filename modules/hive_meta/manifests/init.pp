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

class hive_meta {
  require hive_client
  require hive_db

  $path="/bin:/usr/bin"

  if $security == "true" {
    file { "${hdfs_client::keytab_dir}/hive.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/hive.keytab",
      owner => hive,
      group => hadoop,
      mode => '400',
    }
    ->
    Package["hive_${rpm_version}-metastore"]
  }

  package { "hive${package_version}-metastore":
    ensure => installed,
  }
  ->
  exec { "hdp-select set hive-metastore ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { '/etc/init.d/hive-metastore':
    ensure => file,
    content => template('hive_meta/hive-metastore.erb'),
    mode => 'a+rx',
  }
  ->
  exec { "schematool -dbType mysql -initSchema":
    user => "hive",
    cwd => "/",
    path => "/usr/hdp/current/hive-metastore/bin:$path",
  }
  ->
  service { 'hive-metastore':
    ensure => running,
    enable => true,
  }
}
