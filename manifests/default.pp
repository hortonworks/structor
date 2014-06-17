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

include repos_setup
include vm_users
include ip_setup
include selinux
include weak_random

if $security == "true" {
  include kerberos_client
}

if $security == "true" and hasrole($roles, 'kdc') {
  include kerberos_kdc
}

if hasrole($roles, 'client') {
  if hasrole($clients, 'hdfs') {
    include hdfs_client
  }
  if hasrole($clients, 'yarn') {
    include yarn_client
  }
  if hasrole($clients, 'hive') {
    include hive_client
  }
  if hasrole($clients, 'pig') {
    include pig_client
  }
}

if hasrole($roles, 'nn') {
  include hdfs_namenode
}

if hasrole($roles, 'slave') {
  include hdfs_datanode
  include yarn_node_manager
}

if hasrole($roles, 'yarn') {
  include yarn_resource_manager
}

if hasrole($roles, 'hive-meta') {
  include hive_meta
}

if hasrole($roles, 'hive-db') {
  include hive_db
}

# Ensure the kdc is brought up before the namenode and hive metastore
if $security == "true" and hasrole($roles, 'kdc') {
  if hasrole($roles, 'nn') {
    Class['kerberos_kdc'] -> Class['hdfs_namenode']
  }

  if hasrole($roles, 'hive-meta') {
    Class['kerberos_kdc'] -> Class['hive_meta']
  }
}

# Ensure the namenode is brought up before the slaves, jobtracker or metastore
if hasrole($roles, 'nn') {
  if hasrole($roles, 'slave') {
    Class['hdfs_namenode'] -> Class['hdfs_datanode']
  }

  if hasrole($roles, 'yarn') {
    Class['hdfs_namenode'] -> Class['yarn_resource_manager']
  }

  if hasrole($roles, 'hive-meta') {
    Class['hdfs_namenode'] -> Class['hive_meta']
  }
}
