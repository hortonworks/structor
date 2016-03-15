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

  file { "/etc/profile.d/hbase.sh":
    content => "export HBASE_CONF_PATH=/etc/hbase/conf\n"
  }

  if $security == "true" {
    file { "/etc/hbase":
      ensure => directory,
    }
    ->
    file { "/etc/hbase/conf":
      ensure => directory,
    }
    ->
    file { "/etc/hbase/conf/zk-jaas.conf":
      ensure => file,
      content => template('hbase_client/zk-jaas.erb'),
    }
    ->
    Package["hbase${package_version}"]
  }

  package { "hbase${package_version}":
    ensure => installed,
  }
  ->
  package { "phoenix${package_version}":
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
