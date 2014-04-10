class jdk {
  $ROOT = "/usr/java"
  $VERSION = "jdk1.6.0_31"
  $JDK_URL = "https://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin"

  $HOME = "${ROOT}/default"
  $PATH = "/bin:/usr/bin"
  $DOWNLOAD = "/usr/local/download"

  file {"${ROOT}":
    ensure => "directory",
  }

  file {"${DOWNLOAD}":
    ensure => "directory",
  }

  exec { "${DOWNLOAD}/jdk.bin":
    command => "wget --no-check-certificate ${JDK_URL} -O jdk.bin",
    cwd => "${DOWNLOAD}",
    path => "${PATH}",
    creates => "${DOWNLOAD}/jdk.bin",
  }

  exec { "${ROOT}/${VERSION}":
    command => "sh ${DOWNLOAD}/jdk.bin",
    cwd => "${ROOT}",
    path => "${PATH}",
    creates => "${ROOT}/${VERSION}",
    require => Exec["${DOWNLOAD}/jdk.bin"],
  }

  file { "${ROOT}/default":
    ensure => "link",
    target => "${ROOT}/${VERSION}",
  }

  file { "${ROOT}/${VERSION}/jre/lib/security/local_policy.jar":
    ensure => "file",
    group => "root",
    source => "puppet:///modules/jdk/local_policy.jar",
    require => Exec["${ROOT}/${VERSION}"],
  }

  file { "${ROOT}/${VERSION}/jre/lib/security/US_export_policy.jar":
    ensure => "file",
    group => "root",
    source => "puppet:///modules/jdk/US_export_policy.jar",
    require => Exec["${ROOT}/${VERSION}"],
  }
}