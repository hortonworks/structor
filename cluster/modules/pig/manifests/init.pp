class pig {
  require hadoop_base

  package { 'pig':
    ensure => present,
  }

  file { '/etc/pig':
    ensure => 'directory',
  }

  file { '/etc/pig/default':
    ensure => 'directory',
  }

  file { '/etc/pig/conf':
    ensure => 'link',
    target => '/etc/pig/default',
    require => Package['pig'],
  }

  file { '/etc/pig/default/pig-env.sh':
    ensure => file,
    content => template('pig/pig-env.erb'),
  }

  file { '/etc/pig/default/log4j.properties':
    ensure => file,
    content => template('pig/log4j.erb'),
  }

  file { '/etc/pig/default/pig.properties':
    ensure => file,
    content => template('pig/pig.erb'),
  }
}