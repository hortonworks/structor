# This class replaces /dev/random with /dev/urandom.
# This should *ONLY* be used in virtual machines that don't have enough
# entropy and where the generated keys won't be used in real environments.
class weak_random {
  $path = "/bin:/usr/bin"
  
  exec { '/dev/random' :
    path => $path,
    command => 'rm -f /dev/random; ln -s /dev/urandom /dev/random',
    unless => 'test -L /dev/random',
  }
}