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

class hive_hs2 {
  require hive_client

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
    Package["hive${package_version}-server2"]
  }

  package { "hive${package_version}-server2":
    ensure => installed,
  }
  ->
  file { '/etc/init.d/hive-server2':
    ensure => file,
    source => "/usr/hdp/${hdp_version}/hive/etc/rc.d/init.d/hive-server2",
  }
  ->
  exec { "hdp-select set hive-server2 ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  service { 'hive-server2':
    ensure => running,
    enable => true,
  }
}
