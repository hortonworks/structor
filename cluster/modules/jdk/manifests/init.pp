class jdk {
  $ROOT = "/usr/java"
  $VERSION = "jdk1.6.0_31"

  $HOME = "${ROOT}/default"

  file { "${ROOT}/default":
    ensure => "link",
    target => "${ROOT}/${VERSION}",
  }
}