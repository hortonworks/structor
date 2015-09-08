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

class ambari_agent {

  require repos_setup

  $tmp_dir = "/tmp"
  $conf_dir = "/etc/ambari-agent/conf"

  package { "ambari-agent":
    ensure => installed
  }
  ->  
  file { "${tmp_dir}/ambari-agent":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }
  ->  
  file { "${conf_dir}/ambari-agent.ini":
    ensure => file,
    content => template('ambari_agent/ambari-agent.erb'),
    owner => 'root',
    group => 'root',
    mode => '755',
  }
  ->  
  exec { "ambari-agent-start":
    command => "/usr/sbin/ambari-agent start"
  }

}
