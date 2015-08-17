{
  "ambari_version": "2.1.0",
  "java_version": "java-1.8.0-openjdk",
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 2048,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ ],
  "nodes": [ 
    { "hostname": "ambari",  "ip": "10.0.10.10", "roles": [ "ambari-server" ] },
    { "hostname": "slave1",  "ip": "10.0.10.11", "roles": [ ] }
  ]
}
