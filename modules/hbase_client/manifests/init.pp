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

class hbase_client {
  require hdfs_client
  require zookeeper_client
  require phoenix_client

  $path="/usr/bin"

  if $security == "true" {
    require kerberos_http

    file { "${hbase_client::keytab_dir}/hbase.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/hbase.keytab",
      owner => hbase,
      group => hadoop,
      mode => '400',
    }
  }

  package { "hbase_${rpm_version}":
    ensure => installed,
  }
  ->
  file { '/etc/hbase/conf/hbase-env.sh':
    ensure => file,
    content => template('hbase_client/hbase-env.sh.erb'),
  }
  ->
  file { '/etc/hbase/conf/hbase-site.xml':
    ensure => file,
    content => template('hbase_client/hbase-site.xml.erb'),
  }
  ->
  file { '/etc/hbase/conf/log4j.properties':
    ensure => file,
    content => template('hbase_client/log4j.properties.erb'),
  }
  ->
  file { '/etc/hbase/conf/regionservers':
    ensure => file,
    content => template('hbase_client/regionservers.erb'),
  }
}
