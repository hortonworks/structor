#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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