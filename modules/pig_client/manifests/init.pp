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

class pig_client {
  require yarn_client

  $conf_dir="/etc/pig/hdp"

  package { "pig_${rpm_version}":
    ensure => present,
  }

  file { '/etc/pig':
    ensure => 'directory',
  }

  file { "${conf_dir}":
    ensure => 'directory',
  }

  file { '/etc/pig/conf':
    ensure => 'link',
    target => "${conf_dir}",
    require => Package["pig_${rpm_version}"],
  }

  file { "${conf_dir}/pig-env.sh":
    ensure => file,
    content => template('pig_client/pig-env.erb'),
  }

  file { "${conf_dir}/log4j.properties":
    ensure => file,
    content => template('pig_client/log4j.erb'),
  }

  file { "${conf_dir}/pig.properties":
    ensure => file,
    content => template('pig_client/pig.erb'),
  }
}