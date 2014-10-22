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

class yarn_client {
  require repos_setup
  require jdk
  require hdfs_client

  $user_logs = "/user/yarn/"
  $path="/usr/bin"

  package { "hadoop_${rpm_version}-yarn":
    ensure => installed,
  }
  ->
  file { "/usr/hdp/${hdp_version}/hadoop-yarn/libexec":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hadoop/libexec",
  }

  package { "hadoop_${rpm_version}-mapreduce":
    ensure => installed,
  }
  ->
  file { "/usr/hdp/${hdp_version}/hadoop-mapreduce/libexec":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hadoop/libexec",
  }

  file { "${hdfs_client::conf_dir}/capacity-scheduler.xml":
    ensure => file,
    content => template('yarn_client/capacity-scheduler.erb'),
  }

  file { "${hdfs_client::conf_dir}/mapred-env.sh":
    ensure => file,
    content => template('yarn_client/mapred-env.erb'),
  }

  file { "${hdfs_client::conf_dir}/mapred-site.xml":
    ensure => file,
    content => template('yarn_client/mapred-site.erb'),
  }

  file { "${hdfs_client::conf_dir}/task-log4j.properties":
    ensure => file,
    content => template('yarn_client/task-log4j.erb'),
  }

  file { "${hdfs_client::conf_dir}/yarn.exclude":
    ensure => file,
    content => "",
  }

  file { "${hdfs_client::conf_dir}/yarn-env.sh":
    ensure => file,
    content => template('yarn_client/yarn-env.erb'),
  }

  file { "${hdfs_client::conf_dir}/yarn-site.xml":
    ensure => file,
    content => template('yarn_client/yarn-site.erb'),
  }
}