{
  "java_version": "java-1.8.0-openjdk",
  "hdp_short_version": "2.3.0",
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 3072,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ "hdfs", "zk" ],
  "nodes": [ 
    {"hostname": "spark1", "ip": "240.0.0.11", "roles": ["nn", "zk", "client", "slave", "spark"]}
  ]
}
