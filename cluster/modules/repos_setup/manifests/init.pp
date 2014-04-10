class repos_setup {
  file { '/etc/yum.repos.d/hdp.repo':
    ensure => file,
    content => template('repos_setup/hdp.repo.erb'),
  }
}