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

class kerberos_kdc {
  require kerberos_client
  $path="/bin:/usr/bin:/sbin:/usr/sbin"
  $password="vagrant"

  if ($operatingsystem == "centos") {
    $kdcpath = "/var/kerberos/krb5kdc"
  }
  elsif ($operatingsystem == "ubuntu") {
    $kdcpath = "/etc/krb5kdc"
  }

  case $operatingsystem {
    'centos': {
      package { 'krb5-server':
        ensure => installed,
        before => File["$kdcpath/kdc.conf"]
      }
    }
    'ubuntu': {
      package { 'krb5-kdc':
        ensure => installed,
      }
      ->
      package { 'krb5-admin-server':
        ensure => installed,
        before => File["$kdcpath/kdc.conf"]
      }
    }
  }

  file { "$kdcpath/kdc.conf":
    ensure => file,
    content => template('kerberos_kdc/kdc.erb'),
  }
  ->
  file { '/vagrant/generated':
    ensure => directory,
    mode => 'go-rwx',
  }
  ->
  file { '/vagrant/generated/create-kerberos-db':
    ensure => file,
    content => template('kerberos_kdc/create-kerberos-kdc.erb'),
    mode => 'u=rwx,go=',
  }
  ->
  exec { 'kdc-init':
    command => "/vagrant/generated/create-kerberos-db",
    creates => "$kdcpath/principal",
    path => $path,
  }

  case $operatingsystem {
    'centos': {
      service { 'krb5kdc':
        ensure => running,
        enable => true,
        require => Exec['kdc-init'],
      }
    }
    'ubuntu': {
      service { 'krb5-kdc':
        ensure => running,
        enable => true,
        require => Exec['kdc-init'],
      }
    }
  }
}
