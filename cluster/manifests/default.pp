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
  include hadoop_base
  include pig
  include hive_client
}

if hasrole($roles, 'nn') {
  include hadoop_namenode
}

if hasrole($roles, 'slave') {
  include hadoop_slave
}

if hasrole($roles, 'jt') {
  include hadoop_jobtracker
}

if hasrole($roles, 'hive-meta') {
  include hive_meta
}

if hasrole($roles, 'hive-db') {
  include hive_db
}

if $security == "true" and hasrole($roles, 'nn') and hasrole($roles, 'kdc') {
  Class['kerberos_kdc']
  -> Class['hadoop_namenode']
}

if hasrole($roles, 'nn') and hasrole($roles, 'slave') {
  Class['hadoop_namenode']
  -> Class['hadoop_slave']
}

if hasrole($roles, 'nn') and hasrole($roles, 'jt') {
  Class['hadoop_namenode']
  -> Class['hadoop_jobtracker']
}

if hasrole($roles, 'nn') and hasrole($roles, 'hive-meta') {
  Class['hadoop_namenode']
  -> Class['hive_meta']
}
