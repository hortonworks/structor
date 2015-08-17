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

class install_hdfs_tarballs {
  require hdfs_datanode

  $PATH="/bin:/usr/bin"

  if $security == "true" {
    require load_hdfs_keytab
  }

  if hasrole($clients, 'yarn') {
    require yarn_client

    exec {"install-mr-tarball":
      command => "hadoop fs -put /usr/hdp/${hdp_version}/hadoop/mapreduce.tar.gz /hdp/apps/${hdp_version}/mapreduce/",
      unless =>
        "hadoop fs -test -e /hdp/apps/${hdp_version}/mapreduce/mapreduce.tar.gz",
      path => "$PATH",
      user => "hdfs",
    }
  }

  if hasrole($clients, 'tez') {
    require tez_client

    exec {"install-tez-tarball":
      command => "hadoop fs -put /usr/hdp/${hdp_version}/tez/lib/tez.tar.gz /hdp/apps/${hdp_version}/tez/",
      unless => "hadoop fs -test -e /hdp/apps/${hdp_version}/tez/tez.tar.gz",
      path => "$PATH",
      user => "hdfs",
    }
  }


}
