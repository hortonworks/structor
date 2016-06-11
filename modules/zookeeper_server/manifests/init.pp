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

class zookeeper_server {
  require zookeeper_client

  $path="/usr/bin"

  if $security == "true" {
    file { "${zookeeper_client::conf_dir}/zookeeper-server.jaas":
      ensure => file,
      content => template('zookeeper_server/zookeeper-server.erb'),
    }
    -> Package["zookeeper${package_version}-server"]

    file { "${hdfs_client::keytab_dir}/zookeeper.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/zookeeper.keytab",
      owner => zookeeper,
      group => hadoop,
      mode => '400',
    }
    ->
    Package["zookeeper${package_version}-server"]
  }

  package { "zookeeper${package_version}-server":
    ensure => installed,
  }
  ->
  exec { "hdp-select set zookeeper-server ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "${zookeeper_client::conf_dir}/configuration.xsl":
    ensure => file,
    content => template('zookeeper_server/configuration.erb'),
  }
  ->
  file { "/etc/init.d/zookeeper-server":
    ensure => 'link',
    target => "/usr/hdp/current/zookeeper-server/etc/rc.d/init.d/zookeeper-server",
  }
  ->
  file { "${zookeeper_client::data_dir}":
    ensure => directory,
    owner => zookeeper,
    group => hadoop,
    mode => '700',
  }
  ->
  file { "${zookeeper_client::data_dir}/myid":
    ensure => file,
    content => template('zookeeper_server/myid.erb'),
  }
  ->
  file { "${zookeeper_client::log_dir}":
    ensure => directory,
    owner => zookeeper,
    group => hadoop,
    mode => '700',
  }
  ->
  file { "${zookeeper_client::pid_dir}":
    ensure => directory,
    owner => zookeeper,
    group => hadoop,
    mode => '755',
  }
  ->
  service { "zookeeper-server":
    ensure => running,
    enable => true,
  }
}
