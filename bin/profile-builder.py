#!/usr/bin/python

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

import os
import json
from optparse import OptionParser

def main():
  parser = OptionParser()
  
  # General options
  parser.add_option("-o", "--output", help="output file, default to current.profile", default="current.profile")

  # Cluster size and makeup related options
  parser.add_option("-a", "--ambari", help="Install Ambari on this cluster", default=False)
  parser.add_option("-G", "--no-gateway", help="Set the cluster to not have a gateway node", default=False, dest="no_gateway")
  parser.add_option("-n", "--node-cnt", help="Number of nodes in the cluster, all nodes included", type="int", default=3, dest="nodes")

  # Security options
  parser.add_option("-s", "--secure", help="Setup a secure cluster", default=False)

  (options, args) = parser.parse_args()

  if (os.path.exists(options.output)):
    raise Exception("Output file %s exists, we wouldn't want to overwrite it!" % options.output)

  (nodes, clients) = buildNodes(options)

  output = {}
  output["domain"] = "example.com"
  output["realm"] = "EXAMPLE.COM"
  if (options.secure):
    output["security"] = True
  else:
    output["security"] = False
  output["vm_mem"] = 2048
  output["server_mem"] = 300
  output["client_mem"] = 200
  output["clients"] = clients
  output["nodes"] = nodes

  fd = open(options.output, "w")
  fd.write(json.dumps(output, sort_keys=True, indent=2))
  fd.close()

def buildNodes(options):
  nodes = []

  num_machines = options.nodes

  if (options.ambari):
    num_machines -= 1

  if (num_machines < 1):
    raise Exception("You cannot have a cluster with no machines.  You specified %d nodes, and if you specified Ambari that needs its own node." % options.nodes)

  clients = determineClients(options)

  nodes.append(buildNamenode(options, num_machines))

  # Put Ambari server in if asked for
  if (options.ambari):
    nodes.append(buildAmbariServer)

  # If there are nodes left and they didn't say no gateway, add a gateway
  if (num_machines > 1 and not options.no_gateway):
    nodes.append(buildGateway(options))


  num_slaves = num_machines - 1 # take away one for the namenode
  # We've already substracted one from the machines for the Ambari server if its there
  if (options.no_gateway):
    num_slaves += 1

  if (num_slaves > 0):
    for i in range(num_slaves):
      nodes.append(buildSlave(options, i))

  return (nodes, clients)


def determineClients(options):
  clients = ["hdfs", "tez", "yarn", "zk"] # These three are always there
  # TODO add hive client if asked for
  # TODO add oozie client if asked for
  # TODO add pig client if asked for
  # TODO add ambari agent if asked 
  return clients

def buildNamenode(options, num_machines):
  # Build the NameNode
  nn = {}
  nn["hostname"] = "nn"
  nn["ip"] = "240.0.0.11"
  nn["roles"] = ["nn", "yarn", "zk"]
  if (options.secure):
    nn["roles"].append("kdc")
  if (options.ambari):
    nn["roles"].append("ambari-agent")  # Add Ambari agent if we're installing Ambari
  # TODO add hive-db and hive-meta if asked for

  # If we only have one machine then we need to put a slave and gw on here as well
  if (num_machines == 1):
    nn["roles"].append("slave")
    nn["roles"].append("client")

  return nn

def buildAmbariServer():
  ambari = {}
  ambari["hostname"] = "ambari"
  ambari["ip"] = "240.0.0.15"
  ambari["roles"] = [ "ambari-server" ]
  return ambari

def buildGateway(options):
  gw = {}
  gw["hostname"] = "gw"
  gw["ip"] = "240.0.0.10"
  gw["roles"] = [ "client" ]
  # TODO add knox if asked for
  return gw

def buildSlave(options, slave_num):
  slave = {}
  slave["hostname"] = "slave%d" % (slave_num + 1)
  slave["ip"] = "240.0.0.%d" % (slave_num + 12)
  slave["roles"] = ["slave"]
  if (options.ambari):
    slave["roles"].append("ambari-agent")
  # TODO add hive-server2 to slave1 if requested
  # TODO add oozie to slave1 if requested
  return slave

if __name__ == "__main__":
  main()
