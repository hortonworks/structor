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

class kafka_server {
  require repos_setup
  require zookeeper_server
  require jdk

  $path="/bin:/usr/bin"
 
  # Install and enable. 
  package { "kafka" :
    ensure => installed,
  }
  ->
  service { 'kafka':
    ensure => running,
    enable => true,
  }

  # Configure.
  file { '/etc/kafka/conf/consumer.properties':
    ensure => file,
    content => template('kafka_server/consumer.properties.erb'),
    require => Package['kafka'],
    before => Service['kafka'],
  }
  file { '/etc/kafka/conf/producer.properties':
    ensure => file,
    content => template('kafka_server/producer.properties.erb'),
    require => Package['kafka'],
    before => Service['kafka'],
  }
  file { '/etc/kafka/conf/server.properties':
    ensure => file,
    content => template('kafka_server/server.properties.erb'),
    require => Package['kafka'],
    before => Service['kafka'],
  }

  # Create a topic called test.
# file { "/tmp/create_test_topic.sh":
#   ensure => "file",
#   mode => '755',
#   content => template('kafka_server/create_test_topic.sh.erb'),
# }

  # Startup.
  if ($operatingsystem == "centos" and $operatingsystemmajrelease == "7") {
    file { "/etc/systemd/system/kafka.service":
      ensure => 'file',
      source => "/vagrant/files/systemd/kafka.service",
      require => Package['kafka'],
      before => Service["kafka"],
    }
    file { "/etc/systemd/system/kafka.service.d":
      ensure => 'directory',
    } ->
    file { "/etc/systemd/system/kafka.service.d/default.conf":
      ensure => 'file',
      source => "/vagrant/files/systemd/kafka.service.d/default.conf",
      require => Package['kafka'],
      before => Service["kafka"],
    }
  } else {
    file { "/etc/init.d/kafka":
      ensure => file,
      source => 'puppet:///modules/kafka_server/kafka',
      replace => true,
      require => Package['kafka'],
      before => Service['kafka'],
    }
  }
}
