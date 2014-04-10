class ip_setup {
  service {"iptables":
    ensure => stopped,
    enable => false,
  }

  service {"ip6tables":
    ensure => stopped,
    enable => false,
  }

  file { '/etc/hosts':
    ensure => file,
    content => template('ip_setup/hosts.erb'),
  }
}