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

class pig {
  require hadoop_base

  package { 'pig':
    ensure => present,
  }

  file { '/etc/pig':
    ensure => 'directory',
  }

  file { '/etc/pig/default':
    ensure => 'directory',
  }

  file { '/etc/pig/conf':
    ensure => 'link',
    target => '/etc/pig/default',
    require => Package['pig'],
  }

  file { '/etc/pig/default/pig-env.sh':
    ensure => file,
    content => template('pig/pig-env.erb'),
  }

  file { '/etc/pig/default/log4j.properties':
    ensure => file,
    content => template('pig/log4j.erb'),
  }

  file { '/etc/pig/default/pig.properties':
    ensure => file,
    content => template('pig/pig.erb'),
  }
}