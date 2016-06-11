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

class oozie_server {
  require repos_setup
  require hdp_select
  require hdfs_client
  require hive_client

  $conf_dir = "/etc/oozie/conf"
  $keytab_dir = "/etc/security/hadoop"
  $path="/bin:/usr/bin:/usr/hdp/${hdp_version}/oozie/bin"
  $java_home="${jdk::home}"

  if $security == "true" {
    require kerberos_http

    file { "${keytab_dir}/oozie.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/oozie.keytab",
      owner => oozie,
      group => oozie,
      mode => '400',
    }
    ->
    exec { "kinit -k -t ${keytab_dir}/oozie.keytab oozie/${hostname}.${domain}":
      path => $path,
      user => 'oozie',
    }
    ->
    Package["oozie${package_version}"]

    $prepare_war_opts = "-secure"
  }

  package { "oozie${package_version}":
    ensure => installed,
  }
  ->
  file { "/etc/oozie":
    ensure => directory,
    owner => "root",
    group => "oozie",
    mode => "0750",
  }
  ->
  file { "${conf_dir}/adminusers.txt":
    ensure => file,
    content => template('oozie_server/adminusers.erb'),
  }
  ->
  file { "${conf_dir}/oozie-site.xml":
    ensure => file,
    content => template('oozie_server/oozie-site.erb'),
  }
  ->
  file { "${conf_dir}/oozie-env.sh":
    ensure => file,
    content => template('oozie_server/oozie-env.erb'),
  }
  ->
  file { "/etc/init.d/oozie":
    ensure => file,
    content => template('oozie_server/oozie-service.erb'),
    mode => "0755",
  }
  ->
  package { "extjs":
    ensure => installed,
  }
  ->
  file { "/usr/hdp/${hdp_version}/oozie/libext/ext-2.2.zip":
    ensure => link,
    target => "/usr/share/HDP-oozie/ext-2.2.zip",
  }
  ->
  file { "/usr/hdp/${hdp_version}/oozie/libext/hadoop-lzo.jar":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hadoop/lib/hadoop-lzo-0.6.0.${hdp_version}.jar",
  }
  ->
  file { "/usr/hdp/${hdp_version}/oozie/libext/mysql-connector-java.jar":
    ensure => link,
    target => "/usr/share/java/mysql-connector-java.jar",
  }
  ->
  exec { "oozie-prepare-war":
    path => $path,
    command => "oozie-setup.sh prepare-war ${prepare_war_opts}",
    creates => "/usr/hdp/${hdp_version}/oozie/oozie-server/webapps/oozie.war",
  }
  ->
  file { "/tmp/create-oozie-db-user.sh":
    ensure => file,
    owner => root,
    mode => '0700',
    content => template('oozie_server/create-oozie-db-user.erb'),
  }
  ->
  exec { "oozie-db-user":
    path => $path,
    command => "/tmp/create-oozie-db-user.sh",
  }
  ->
  exec { "oozie-createdb":
    path => $path,
    environment => "JAVA_HOME=${java_home}",
    command => "ooziedb.sh create -sqlfile /tmp/oozie.sql -run",
    creates => "/tmp/oozie.sql",
    user => 'oozie',
    group => 'oozie',
  }
  ->
  exec { "untar-oozie-sharelib":
    path => $path,
    cwd => "/tmp",
    command => "tar xzf /usr/hdp/${hdp_version}/oozie/oozie-sharelib.tar.gz",
    creates => "/tmp/share",
    user => 'oozie',
    group => 'oozie',
  }
  ->
  file { "/tmp/share/lib/hive/mysql-connector-java.jar":
    ensure => file,
    source => "/usr/share/java/mysql-connector-java.jar",
    owner => 'oozie',
    group => 'oozie',
    mode => "0644",
  }
  ->
  exec { "install-oozie-sharelib":
    path => $path,
    cwd => "/tmp",
    command => "hadoop fs -put share /user/oozie/",
    unless =>
      "hadoop fs -test -e /user/oozie/share",
    user => 'oozie',
  }
  ->
  service { "oozie":
    ensure => running,
    enable => true,
  }
}
