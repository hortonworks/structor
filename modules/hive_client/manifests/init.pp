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

class hive_client {
  require yarn_client

  package { "hive${package_version}":
    ensure => installed,
  }

  file { '/etc/hive':
    ensure => 'directory',
  }

  file { '/etc/hive/hdp':
    ensure => 'directory',
  }

  file { '/etc/hive/conf':
    ensure => 'link',
    target => '/etc/hive/hdp',
    require => Package["hive${package_version}"],
    force => true
  }

  file { '/etc/hive/hdp/hive-env.sh':
    ensure => file,
    content => template('hive_client/hive-env.erb'),
  }

  file { '/etc/hive/hdp/hive-site.xml':
    ensure => file,
    content => template('hive_client/hive-site.erb'),
  }

  file { '/etc/hive/hdp/hive-log4j.properties':
    ensure => file,
    content => template('hive_client/hive-log4j.erb'),
  }

  package { 'mysql-connector-java':
    ensure => installed,
  }

  file { "/usr/hdp/${hdp_version}/hive/lib/mysql-connector-java.jar":
    ensure => 'link',
    target => '/usr/share/java/mysql-connector-java.jar',
    require => Package["hive${package_version}"],
  }
}
