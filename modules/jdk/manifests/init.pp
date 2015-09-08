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

class jdk {
  $HOME = "/usr/lib/jvm/java"

  if ($operatingsystem == "centos") {
    package { "java-1.7.0-openjdk":
      ensure => installed,
    }

    package { "java-1.7.0-openjdk-devel":
      ensure => installed,
    }
  }
  elsif ($operatingsystem == "ubuntu") {
    package { "openjdk-7-jdk":
      ensure => installed,
    }
    ->
    file { $HOME:
      ensure => 'link',
      target => '/usr/lib/jvm/java-7-openjdk-amd64',
      force => true
    }
    ->
    file { "/usr/java":
      ensure => 'directory'
    }
    ->
    file { "/usr/java/default":
      ensure => 'link',
      target => '/usr/lib/jvm/java',
      force => true
    }
  }

  file { "/etc/profile.d/java.sh":
    ensure => "file",
    content => template('jdk/java.erb'),
  }
}
