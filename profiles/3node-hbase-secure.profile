{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": true,
  "vm_mem": 2048,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ "hbase", "hdfs", "zk"],
  "nodes": [
    { "hostname": "gw", "ip": "240.0.0.10", "roles": [ "client" ]},
    { "hostname": "nn", "ip": "240.0.0.11",
      "roles": [ "hbase-master", "kdc", "nn", "slave", "zk" ] },
    { "hostname": "slave1", "ip": "240.0.0.12",
      "roles": [ "hbase-regionserver", "slave" ] }
  ]
}
