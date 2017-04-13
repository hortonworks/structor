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
include ntp

# determine the required modules based on the roles.

if $security == "true" {
  include kerberos_client
}

if $security == "true" and hasrole($roles, 'kdc') {
  include kerberos_kdc
}

if hasrole($roles, 'ambari-agent') {
  include ambari_agent
}

if hasrole($roles, 'ambari-server') {
  include ambari_server
}

if hasrole($roles, 'cert') {
   include certification
}

if hasrole($roles, 'client') {
  if hasrole($clients, 'hbase') {
    include hbase_client
  }
  if hasrole($clients, 'spark') {
    include spark_client
  }
  if hasrole($clients, 'hdfs') {
    include hdfs_client
  }
  if hasrole($clients, 'hive') {
    include hive_client
  }
  if hasrole($clients, 'oozie') {
    include oozie_client
  }
  if hasrole($clients, 'pig') {
    include pig_client
  }
  if hasrole($clients, 'tez') {
    include tez_client
  }
  if hasrole($clients, 'yarn') {
    include yarn_client
  }
  if hasrole($clients, 'zk') {
    include zookeeper_client
  }
}

if hasrole($roles, 'dev') {
  include dev
}

if hasrole($roles, 'hbase-master') {
  include hbase_master
}

if hasrole($roles, 'hbase-regionserver') {
  include hbase_regionserver
}

if hasrole($roles, 'hive-db') {
  include hive_db
}

if hasrole($roles, 'hive-meta') {
  include hive_meta
}

if hasrole($roles, 'hive-hs2') {
  include hive_hs2
}

if hasrole($roles, 'knox') {
  include knox_gateway
}

if hasrole($roles, 'nn') {
  include hdfs_namenode
}

if hasrole($roles, 'oozie') {
  include oozie_server
}

if hasrole($roles, 'slave') {
  include hdfs_datanode
  include yarn_node_manager
}

if hasrole($roles, 'yarn') {
  include yarn_resource_manager
}

if hasrole($roles, 'zk') {
  include zookeeper_server
}

if hasrole($roles, 'kafka') {
  include kafka_server
}

if hasrole($roles, 'storm_nimbus') {
  include storm_server
}

if hasrole($roles, 'storm_worker') {
  include storm_server
}

if islastslave($nodes, $hostname) {
  include install_hdfs_tarballs
}

# Ensure the kdc is brought up before the namenode and hive metastore
if $security == "true" and hasrole($roles, 'kdc') {
  if hasrole($roles, 'nn') {
    Class['kerberos_kdc'] -> Class['hdfs_namenode']
  }

  if hasrole($roles, 'hive-meta') {
    Class['kerberos_kdc'] -> Class['hive_meta']
  }

  if hasrole($roles, 'hbase-master') {
    Class['kerberos_kdc'] -> Class['hbase_master']
  }

  if hasrole($roles, 'hbase-regionserver') {
    Class['kerberos_kdc'] -> Class['hbase_regionserver']
  }
}

# Ensure the namenode is brought up before the slaves, jobtracker, metastore,
# and oozie
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

  if hasrole($roles, 'oozie') {
    Class['hdfs_namenode'] -> Class['oozie_server']
  }

  if hasrole($roles, 'hbase-master') {
    Class['hdfs_namenode'] -> Class['hbase_master']
  }

  if hasrole($roles, 'hbase-regionserver') {
    Class['hdfs_namenode'] -> Class['hbase_regionserver']
  }
}

# Ensure the db is started before oozie and hive metastore
if hasrole($roles, 'hive-db') {
  if hasrole($roles, 'hive-meta') {
    Class['hive_db'] -> Class['hive_meta']
  }

  if hasrole($roles, 'oozie') {
    Class['hive_db'] -> Class['oozie_server']
  }
}

# Ensure oozie runs after the datanode on the same node
if hasrole($roles, 'slave') and hasrole($roles, 'oozie') {
  Class['hdfs_datanode'] -> Class['oozie_server']
}

if hasrole($roles, 'hbase-master') {
  if hasrole($roles, 'hbase-regionserver') {
    Class['hbase_master'] -> Class['hbase_regionserver']
  }

  # The master needs a datanode before it can start up
  if hasrole($roles, 'slave') {
    Class['hdfs_datanode'] -> Class['hbase_master']
  }
}
