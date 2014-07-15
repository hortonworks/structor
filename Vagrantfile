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

require 'json'

VAGRANTFILE_API_VERSION = "2"

# Profile search path:
$profile_path = ["current.profile",
                 "profiles/default.profile"]

###############################################################################
# Loads a profile, which is a JSON file describing a specific configuation.
#
# The user should create a symlink from current.profile to the desired
# profile.
def loadProfile()
  $profile_path.each { |file| 
    if file and File.file?(file)
      puts "Loading profile %s\n" % [File.realpath(file)]
      return JSON.parse( IO.read( file ), opts = { symbolize_names: true } )
    end
  }
end

profile = loadProfile()

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # All Vagrant configuration is done here. The most common configuration
  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = "nrel/CentOS-6.5-x86_64" # This is a more current and much smaller base box that may work.
  config.vm.box = "omalley/centos6_x64"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", profile[:vm_mem] ]
  end

  config.vm.provider :vmware_fusion do |vm|
    vm.vmx["memsize"] = profile[:vm_mem]
  end

  profile[:nodes].each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.hostname = node[:hostname] + "." + profile[:domain]
      node_config.vm.network :private_network, ip: node[:ip]
      node_config.vm.provision "puppet" do |puppet|
        puppet.module_path = "modules"
        puppet.options = ["--libdir", "/vagrant", 
            "--fileserverconfig=/vagrant/fileserver.conf"]
        puppet.facter = {
          "hostname" => node[:hostname],
          "roles" => node[:roles],
          "nodes" => profile[:nodes],
          "domain" => profile[:domain],
          "security" => profile[:security],
          "realm" => profile[:realm],
          "clients" => profile[:clients],
          "server_mem" => profile[:server_mem],
          "client_mem" => profile[:client_mem],
          "profile" => profile
        }
      end
    end
  end

end
