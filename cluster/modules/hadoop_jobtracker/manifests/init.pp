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