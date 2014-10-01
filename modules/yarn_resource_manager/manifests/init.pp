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

class yarn_resource_manager {
  require yarn_client
  require hadoop_server

  if $security == "true" {
    require kerberos_http

    file { "${hdfs_client::keytab_dir}/rm.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/rm.keytab",
      owner => 'yarn',
      group => 'hadoop',
      mode => '400',
    }
    ->
    Package["hadoop_${rpm_version}-mapreduce-historyserver"]

    file { "${hdfs_client::keytab_dir}/jhs.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/jhs.keytab",
      owner => 'mapred',
      group => 'hadoop',
      mode => '400',
    }
    ->
    Package["hadoop_${rpm_version}-yarn-resourcemanager"]
  }

  package { "hadoop_${rpm_version}-yarn-resourcemanager" :
    ensure => installed,
  }
  ->
  file { "/etc/init.d/hadoop-yarn-resourcemanager":
    ensure => file,
    source => "puppet:///files/init.d/hadoop-yarn-resourcemanager",
    owner => root,
    group => root,
  }
  ->
  service {"hadoop-yarn-resourcemanager":
    ensure => running,
    enable => true,
  }

  package { "hadoop_${rpm_version}-mapreduce-historyserver" :
    ensure => installed,
  }
  ->
  file { "/etc/init.d/hadoop-mapreduce-historyserver":
    ensure => file,
    source => "puppet:///files/init.d/hadoop-mapreduce-historyserver",
    owner => root,
    group => root,
  }
  ->
  service {"hadoop-mapreduce-historyserver":
    ensure => running,
    enable => true,
  }
}