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

class hadoop_jobtracker {
  require hadoop_base

  $PATH = "/bin:/usr/bin"

  if $security == "true" {
    require kerberos_http

    file { "/etc/security/hadoop/jt.keytab":
      ensure => file,
      source => "/vagrant/generated/keytabs/${hostname}/jt.keytab",
      owner => 'mapred',
      group => 'hadoop',
      mode => '400',
    }
    ->
    Package['hadoop-jobtracker']
  }

  package { "hadoop-jobtracker" :
    ensure => installed,
  }
  ->
  service {"hadoop-jobtracker":
    ensure => running,
    enable => true,
  }
}