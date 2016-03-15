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

class hbase_regionserver {
  require hbase_server

  $path="/bin:/sbin:/usr/bin"

  case $operatingsystem {
    'centos': {
      package { "hbase${package_version}-regionserver" :
        ensure => installed,
      }
    }
    # XXX: Work around BUG-39010.
    'ubuntu': {
      exec { "apt-get download hbase${package_version}-regionserver":
        cwd => "/tmp",
        path => "$path",
      }
      ->
      exec { "dpkg -i --force-overwrite hbase${package_version}*.deb":
        cwd => "/tmp",
        path => "$path",
        user => "root",
      }
      # Fix incorrect startup script permissions (XXX: Is a bug filed for this?).
      ->
      file { "/usr/hdp/${hdp_version}/etc/init.d/hbase-regionserver":
        ensure => file,
        mode => '755',
      }
    }
  }
  ->
  exec { "hdp-select set hbase-regionserver ${hdp_version}":
    cwd => "/",
    path => "$path",
  }
  ->
  file { "/etc/init.d/hbase-regionserver":
    ensure => file,
    source => "puppet:///files/init.d/hbase-regionserver",
    owner => root,
    group => root,
  }
  ->
  service {"hbase-regionserver":
    ensure => running,
    enable => true,
    subscribe => File['/etc/hbase/conf/hbase-site.xml'],
  }
}
