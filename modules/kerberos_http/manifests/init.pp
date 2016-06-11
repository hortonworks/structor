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

class kerberos_http {
  require hadoop_server
  require kerberos_client
  require ssl_ca

  if hasrole($roles, 'kdc') {
    Class['kerberos_kdc'] -> Class['kerberos_http']
  }

  $path = "${jdk::home}/bin:/bin:/usr/bin"

  file { "${hdfs_client::keytab_dir}":
    ensure => directory,
    owner => 'root',
    group => 'hadoop',
    mode => '750',
  }
  ->
  file { "${hdfs_client::keytab_dir}/http-secret":
    ensure => file,
    # this needs to be a cluster wide secret
    content => vagrant,
    owner => root,
    group => hadoop,
    mode => '440',
  }
  ->
  file { "${hdfs_client::keytab_dir}/http.keytab":
    ensure => file,
    source => "/vagrant/generated/keytabs/${hostname}/HTTP.keytab",
    owner => 'root',
    group => 'hadoop',
    mode => '440',
  }
  ->
  file { "/tmp/create-cert":
    ensure => file,
    content => template('kerberos_http/create-cert.erb'),
    mode => '700',
  }
  ->
  exec { '/tmp/create-cert':
    creates => "${hdfs_client::keytab_dir}/server.crt",
    cwd => "${hdfs_client::keytab_dir}",
    path => '$path',
    provider => shell,
  }
  
  file { "${hdfs_client::conf_dir}/ssl-server.xml":
    ensure => file,
    owner => 'root',
    group => 'hadoop',
    mode => '640',
    content => template('kerberos_http/ssl-server.erb'),
  }
}
