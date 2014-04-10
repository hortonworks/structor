class selinux {
  file { '/etc/selinux/config':
    ensure => file,
    content => template('selinux/selinux.erb'),
  }
}