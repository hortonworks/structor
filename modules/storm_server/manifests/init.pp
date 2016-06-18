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

class storm_server {
  require repos_setup
  require zookeeper_client
  require jdk

  $path="/bin:/usr/bin"

  # Install and enable. 
  package { "storm" :
    ensure => installed,
  }
  ->
  exec { "hdp-select set storm-client ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  exec { "hdp-select set storm-supervisor ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/storm/conf/storm.yaml":
    ensure => file,
    content => template('storm_server/storm-yaml.erb'),
  }
  ->
  file { "/etc/init.d/storm-supervisor":
    ensure => file,
    content => epp('storm_server/storm-init.epp',
        {'service' => 'supervisor', 'name' => 'Storm Supervisor'}),
    mode => '755',
  }
  ->
  service {"storm-supervisor":
    ensure => running,
    enable => true,
  }

  if hasrole($roles, 'storm_nimbus') {
    exec { "hdp-select set storm-nimbus ${hdp_version}":
      cwd => "/",
      path => "$path",
    }
    ->
    file { "/etc/init.d/storm-nimbus":
      ensure => file,
      content => epp('storm_server/storm-init.epp',
        {'service' => 'nimbus', 'name' => 'Storm Nimbus'}),
      mode => '755',
    }
    ->
    service {"storm-nimbus":
      ensure => running,
      enable => true,
      require => File['/etc/storm/conf/storm.yaml'],
    }

    file { "/etc/init.d/storm-ui":
      ensure => file,
      content => epp('storm_server/storm-init.epp',
        {'service' => 'ui', 'name' => 'Storm UI'}),
      mode => '755',
    }
    ->
    service {"storm-ui":
      ensure => running,
      enable => true,
      require => File['/etc/storm/conf/storm.yaml'],
    }

    file { "/etc/init.d/storm-logviewer":
      ensure => file,
      content => epp('storm_server/storm-init.epp',
        {'service' => 'logviewer', 'name' => 'Storm Log Viewer'}),
      mode => '755',
    }
    ->
    service {"storm-logviewer":
      ensure => running,
      enable => true,
      require => File['/etc/storm/conf/storm.yaml'],
    }

    file { "/etc/init.d/storm-drpc":
      ensure => file,
      content => epp('storm_server/storm-init.epp',
        {'service' => 'drpc', 'name' => 'Storm DRPC'}),
      mode => '755',
    }
    ->
    service {"storm-drpc":
      ensure => running,
      enable => true,
      require => File['/etc/storm/conf/storm.yaml'],
    }
  }

  # TODO deal with security


}
