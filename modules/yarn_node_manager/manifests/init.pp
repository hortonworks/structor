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

class yarn_node_manager {
  require yarn_client
  require hadoop_server

  $path="/usr/bin"

  if $security == "true" {
    require kerberos_http

    file { "${hdfs_client::keytab_dir}/nm.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/nm.keytab",
      owner => yarn,
      group => hadoop,
      mode => '400',
    }
    ->
    file { "${hdfs_client::conf_dir}/container-executor.cfg":
      ensure => file,
      content => template('yarn_node_manager/container-executor.erb'),
      owner => root,
      group => mapred,
      mode => 400,
    }
    ->
    Package["hadoop_${rpm_version}-yarn-nodemanager"]
  }

  package { "hadoop_${rpm_version}-yarn-nodemanager" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-yarn-nodemanager ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hadoop-yarn-nodemanager":
    ensure => 'link',
    target => "/usr/hdp/current/hadoop-yarn-nodemanager/etc/rc.d/init.d/hadoop-yarn-nodemanager",
  }
  ->
  service {"hadoop-yarn-nodemanager":
    ensure => running,
    enable => true,
  }

}
