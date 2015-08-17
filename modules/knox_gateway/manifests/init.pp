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

class knox_gateway {
  require repos_setup
  
  package { "knox.noarch" :
    ensure => installed,
  }
  ->
  file { "/etc/init.d/knox-gateway":
    ensure => file,
    source => "puppet:///files/init.d/knox-gateway",
    owner => root,
    group => root,
  }
  ->
  exec { 'start-ldap' :
    path   => "/usr/bin:/usr/sbin:/bin",
    command => 'su -l knox -c "/usr/lib/knox/bin/ldap.sh start"',
  }
  ->
  exec { 'setup-gateway' :
    path   => "/usr/bin:/usr/sbin:/bin",
    command => 'su -l knox -c "/usr/lib/knox/bin/knoxcli.sh create-master --master test-master-secret"',
  }
  ->
  service {"knox-gateway":
    ensure => running,
    enable => true,
  }
}
