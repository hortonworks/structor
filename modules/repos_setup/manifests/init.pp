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

class repos_setup {
  $PATH="/bin:/usr/bin"

  if ($operatingsystem == "centos") {
    file { '/etc/yum.repos.d/hdp.repo':
      ensure => file,
      source => "puppet:///files/repos/hdp.repo.${hdp_short_version}",
    }
    file { '/etc/yum.repos.d/ambari.repo':
      ensure => file,
      source => "puppet:///files/repos/ambari.repo.${ambari_version}",
    }
    package { 'epel-release-6-8':
      ensure => absent,
    }
  }
  elsif ($operatingsystem == "ubuntu") {
    file { '/etc/apt/sources.list.d/hdp.list':
      ensure => file,
      source => "puppet:///files/repos/hdp.list.${hdp_short_version}",
    }
    ->
    exec { "gpg-updates-import":
      command => "gpg --keyserver pgp.mit.edu --recv-keys B9733A7A07513CAD",
      path => "$PATH",
    }
    ->
    exec { "gpg-updates-aptkey":
      command => "gpg -a --export 07513CAD | apt-key add -",
      path => "$PATH",
    }
    ->
    exec { "refresh-apt-cache":
      command => "apt-get update",
      path => "$PATH",
    }
  }
}
