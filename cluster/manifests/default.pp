include ip_setup
include selinux

if hasrole($roles, 'client') {
  include hadoop_base
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

if hasrole($roles, 'nn') and hasrole($roles, 'slave') {
  Class['hadoop_namenode']
  -> Class['hadoop_slave']
}

if hasrole($roles, 'nn') and hasrole($roles, 'jt') {
  Class['hadoop_namenode']
  -> Class['hadoop_jobtracker']
}
