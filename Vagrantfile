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

# Valid roles are:
#   client - client machine
#   kdc - kerberos kdc
#   nn - HDFS NameNode
#   yarn - Yarn Resource Manager and MapReduce Job History Server
#   slave - HDFS DataNode & Yarn Node Manager
#   hive-db - Hive MetaStore backing mysql
#   hive-meta - Hive MetaStore
#   zk - Zookeeper Server

###############################################################################
# Loads a profile, which is a JSON object describing a specific configuation.
# First looks for a file in the current directory named profile.json
# Then looks for profiles/custom.json and then for profiles/default.json
# The suggesion is to create a symlink named profile.json in the root linked 
# to the to desired profile in the profiles directory.  The profile.json and 
# custom.json names have been added to .gitignore to avoid either 
# accidentially being pushed to the origin repo.
###############################################################################
def loadProfile()
  profiles = 'profiles'
  file = 'profile.json'
  if !File.file?( file )
    file = File.join( profiles, 'custom.json' )
    if !File.file?( file )
      file = File.join( profiles, 'default.json' )
    end
  end
  puts "Loading profile %s\n" % [File.realpath(file)]
  return JSON.parse( IO.read( file ), opts = { symbolize_names: true } )
end

profile = loadProfile()
#puts JSON.pretty_generate( profile )

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # All Vagrant configuration is done here. The most common configuration
  # Every Vagrant virtual environment requires a box to build off of.
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