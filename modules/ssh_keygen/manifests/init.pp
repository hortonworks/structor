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

class ssh_keygen {
  $path = "/bin:/usr/bin"

  file { '/root/.ssh':
    ensure => directory,
    mode => 'go-rwx',
  }
  ->
  file { '/root/.ssh/id_rsa':
    ensure => file,
    source => 'puppet:///modules/ssh_keygen/id_rsa',
    owner => root,
    group => root,
    mode => '600',
  }
  ->
  file { '/root/.ssh/id_rsa.pub':
    ensure => file,
    source => 'puppet:///modules/ssh_keygen/id_rsa.pub',
    owner => root,
    group => root,
    mode => '644',
  }
  ->
  file { '/root/.ssh/authorized_keys':
    ensure => file,
    source => 'puppet:///modules/ssh_keygen/authorized_keys',
    owner => root,
    group => root,
    mode => '644',
  }
  ->
  exec { 'known_hosts' :
    path => $path,
    command => 'ssh-keyscan -H `hostname` > /root/.ssh/known_hosts',
    unless => 'test -f /root/.ssh/known_hosts',
  }
}
