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

class hdfs_client {
  require repos_setup
  require hdp_select
  require jdk

  $conf_dir="/etc/hadoop/hdp"
  $path="${jdk::home}/bin:/bin:/usr/bin"
  $log_dir="/var/log/hadoop"
  $data_dir="/var/lib/hadoop"
  $pid_dir="/var/run/pid"
  $keytab_dir="/etc/security/hadoop"

  package { "hadoop${package_version}":
    ensure => installed,
  }
  ->
  exec { "hdp-select set hadoop-client ${hdp_version}":
    cwd => "/",
    path => "$path",
  }

  package { "hadoop${package_version}-libhdfs":
    ensure => installed,
    require => Package["hadoop${package_version}"],
  }

  package { "hadoop${package_version}-client":
    ensure => installed,
    require => Package["hadoop${package_version}"],
  }

  package { 'openssl':
    ensure => installed,
  }

  package { 'snappy':
    ensure => installed,
  }

  file { '/etc/hadoop':
    ensure => 'directory',
  }

  file { "${conf_dir}":
    ensure => 'directory',
  }

  file { '/etc/hadoop/conf':
    ensure => 'link',
    target => "${conf_dir}",
    require => Package["hadoop${package_version}"],
    force => true
  }

  file { "${conf_dir}/commons-logging.properties":
    ensure => file,
    content => template('hdfs_client/commons-logging.erb'),
  }

  file { "${conf_dir}/configuration.xsl":
    ensure => file,
    content => template('hdfs_client/configuration.erb'),
  }

  file { "${conf_dir}/core-site.xml":
    ensure => file,
    content => template('hdfs_client/core-site.erb'),
  }

  file { "${conf_dir}/dfs.exclude":
    ensure => file,
    content => "",
  }

  file { "${conf_dir}/hadoop-env.sh":
    ensure => file,
    content => template('hdfs_client/hadoop-env.erb'),
  }

  file { "${conf_dir}/hadoop-metrics2.properties":
    ensure => file,
    content => template('hdfs_client/hadoop-metrics2.erb'),
  }

  file { "${conf_dir}/hadoop-policy.xml":
    ensure => file,
    content => template('hdfs_client/hadoop-policy.erb'),
  }

  file { "${conf_dir}/hdfs-site.xml":
    ensure => file,
    content => template('hdfs_client/hdfs-site.erb'),
  }

  file { "${conf_dir}/log4j.properties":
    ensure => file,
    content => template('hdfs_client/log4j.erb'),
  }

  if $security == "true" {
    require kerberos_client
    require ssl_ca

    # bless the generated ca cert for java clients
    exec {"keytool -importcert -noprompt -alias horton-ca -keystore ${jdk::home}/jre/lib/security/cacerts -storepass changeit -file ca.crt":
      cwd => "/vagrant/generated/ssl-ca",
      path => "$path",
      unless => "keytool -list -alias horton-ca -keystore ${jdk::home}/jre/lib/security/cacerts -storepass changeit",
    }

    file {"${conf_dir}/ssl-client.xml":
      ensure => file,
      content => template("hdfs_client/ssl-client.erb"),
    }
  }

}
