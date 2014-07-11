{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 3072,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ "hdfs", "yarn", "pig", "hive", "zk" ],
  "nodes": [ 
    {"hostname": "nn", "ip": "240.0.0.11", 
     "roles": ["nn", "yarn", "hive-meta", "hive-db", "zk", "client", "slave"]}
  ]
}
