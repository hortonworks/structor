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
                 "profiles/3node-nonsecure.profile"]

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

# Pull the HDP version out of the repository file.
def findVersion(profile)
  if (profile[:os] == "centos")
    path = 'files/repos/hdp.repo.%s' % profile[:hdp_short_version]
  elsif (profile[:os] == "ubuntu")
    path = 'files/repos/hdp.list.%s' % profile[:hdp_short_version]
  end
  
  fileObj = File.new(path, 'r')
  match = /^#VERSION_NUMBER=(?<ver>[-0-9.]*)/.match(fileObj.gets)
  fileObj.close()
  result = match['ver']
  puts "HDP Build = %s\n" % result
  return result
end

###############################################################################
# Define cluster

profile = loadProfile()

# Set defaults.
default_os = "centos"
default_hdp_short_version = "2.2.6"
default_ambari_version = "2.1.0"
default_java_version = "java-1.7.0-openjdk"

profile[:hdp_short_version] ||= default_hdp_short_version
profile[:ambari_version] ||= default_ambari_version
profile[:java_version] ||= default_java_version
profile[:os] ||= default_os
hdp_version = findVersion(profile)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    config.cache.scope = :box
  end

  # All Vagrant configuration is done here. The most common configuration
  # Every Vagrant virtual environment requires a box to build off of.
  if (profile[:os] == "centos")
    config.vm.box = "omalley/centos6_x64"
    package_version = "_" + (hdp_version.gsub /[.-]/, '_')
    start_script_path = "rc.d/init.d"
  elsif (profile[:os] == "ubuntu")
    config.vm.box = "ubuntu/trusty64"
    package_version = "-" + (hdp_version.gsub /[.-]/, '-')
    start_script_path = "init.d"
  end

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
      node_config.ssh.forward_agent = true
      node_config.vm.provision "puppet" do |puppet|
        puppet.module_path = "modules"
        puppet.options = ["--libdir", "/vagrant", 
	    "--verbose", "--debug",
            "--fileserverconfig=/vagrant/fileserver.conf"]
        puppet.facter = {
          "hdp_short_version" => profile[:hdp_short_version],
          "ambari_version" => profile[:ambari_version],
	  "package_version" => package_version,
          "start_script_path" => start_script_path,

          "hostname" => node[:hostname],
          "roles" => node[:roles],
          "nodes" => profile[:nodes],
	  "hdp_version" => hdp_version,
          "domain" => profile[:domain],
          "security" => profile[:security],
          "realm" => profile[:realm],
          "clients" => profile[:clients],
          "server_mem" => profile[:server_mem],
          "client_mem" => profile[:client_mem],
          "profile" => profile,
        }
      end
    end
  end

end
