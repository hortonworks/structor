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
