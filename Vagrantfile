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

# Default versions.
default_hdp_short_version = "2.3.0"
default_ambari_version = "2.1.0"
default_java_version = "java-1.7.0-openjdk"

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

# Pull the HDP version out of the hdp.repo file
def findVersion(version)
  fileObj = File.new('files/repos/hdp.repo.%s' % version, 'r')
  match = /^#VERSION_NUMBER=(?<ver>[-0-9.]*)/.match(fileObj.gets)
  fileObj.close()
  result = match['ver']
  puts "HDP Build = %s\n" % result
  return result
end

###############################################################################
# Define cluster
profile = loadProfile()

# Versions
hdp_short_version = profile[:hdp_short_version] || default_hdp_short_version
ambari_version = profile[:ambari_version] || default_ambari_version
java_version = profile[:java_version] || default_java_version
java_home = "/etc/alternatives/jre"
puts "Ambari Version = %s\n" % ambari_version
puts "Java Version = %s\n" % java_version
hdp_version = findVersion(hdp_short_version)
rpm_version = hdp_version.gsub /[.-]/, '_'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    config.cache.scope = :box
  end

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
      node_config.ssh.forward_agent = true

      node_config.vm.provision :shell do |shell|
        shell.inline = "
          if [ ! -d /etc/puppet/modules/java ] ; then
            mkdir -p /etc/puppet/modules;
            puppet module install puppetlabs/java;
          fi"
      end

      node_config.vm.provision "puppet" do |puppet|
        puppet.module_path = "modules"
        puppet.options = ["--libdir", "/vagrant", 
            "--fileserverconfig=/vagrant/fileserver.conf"]
        puppet.facter = {
          "hdp_short_version" => hdp_short_version,
          "hdp_version" => hdp_version,
          "ambari_version" => ambari_version,
          "java_version" => java_version,
	  "java_home" => java_home,
	  "rpm_version" => rpm_version,

          "server_mem" => profile[:server_mem],
          "client_mem" => profile[:client_mem],
          "hbase_master_mem" => profile[:hbase_master_mem],
          "hbase_regionserver_mem" => profile[:hbase_regionserver_mem],

          "hostname" => node[:hostname],
          "roles" => node[:roles],
          "nodes" => profile[:nodes],
          "domain" => profile[:domain],
          "security" => profile[:security],
          "realm" => profile[:realm],
          "clients" => profile[:clients],
          "profile" => profile
        }
      end
    end
  end

end
