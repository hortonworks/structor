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

class tez_client {
  require yarn_client

  $conf_dir="/etc/tez/hdp"

  package { "tez${package_version}":
    ensure => installed,
  }
  ->
  file { "/etc/tez":
    ensure => directory,
  }
  ->
  file { "${conf_dir}":
    ensure => 'directory',
  }
  ->
  file { '/etc/tez/conf':
    ensure => 'link',
    target => "${conf_dir}",
    force => true
  }

  file { "${conf_dir}/tez-env.sh":
    ensure => file,
    content => template('tez_client/tez-env.erb'),
  }

  file { "${conf_dir}/tez-site.xml":
    ensure => file,
    content => template('tez_client/tez-site.erb'),
  }
}
