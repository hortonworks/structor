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

class zookeeper_client {
  require repos_setup
  require hdp_select
  require jdk

  $conf_dir="/etc/zookeeper/hdp"
  $log_dir="/var/log/zookeeper"
  $data_dir="/var/run/zookeeper"
  $pid_dir="/var/run/pid/zookeeper"
  $path="/usr/bin"

  package { "zookeeper_${rpm_version}":
    ensure => installed,
  }
  ->
  exec { "hdp-select set zookeeper-client ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { '/usr/hdp/current/zookeeper-client/bin/zkCli.sh':
    ensure => file,
    source => "puppet:///files/zk-2053/zkCli.sh",
    owner => root,
    group => root,
    mode => 755,
  }
  ->
  file { '/usr/hdp/current/zookeeper-client/bin/zkEnv.sh':
    ensure => file,
    source => "puppet:///files/zk-2053/zkEnv.sh",
    owner => root,
    group => root,
    mode => 755,
  }
  
  file { '/etc/zookeeper':
    ensure => 'directory',
  }

  file { "${conf_dir}":
    ensure => 'directory',
  }

  file { '/etc/zookeeper/conf':
    ensure => 'link',
    target => "${conf_dir}",
    require => Package["zookeeper_${rpm_version}"],
  }


  file { "${conf_dir}/log4j.properties":
    ensure => file,
    content => template('zookeeper_client/log4j.erb'),
  }

  file { "${conf_dir}/zoo.cfg":
    ensure => file,
    content => template('zookeeper_client/zoo.erb'),
  }

  file { "${conf_dir}/zookeeper-env.sh":
    ensure => file,
    content => template('zookeeper_client/zookeeper-env.erb'),
  }

  if $security == "true" {
    file { "${conf_dir}/zookeeper-client.jaas":
      ensure => file,
      content => template('zookeeper_client/zookeeper-client.erb'),
    }
  }
}