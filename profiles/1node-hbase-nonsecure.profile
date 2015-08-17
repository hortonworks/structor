{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 3072,
  "server_mem": 300,
  "client_mem": 200,
  "hbase_master_mem": 1024,
  "hbase_regionserver_mem": 1024,
  "clients" : [ "hdfs", "zk", "phoenix" ],
  "nodes": [ 
    {"hostname": "nn", "ip": "240.0.0.11", 
     "roles": ["nn", "zk", "hbase-master", "hbase-regionserver", "client", "slave"]}
  ]
}
