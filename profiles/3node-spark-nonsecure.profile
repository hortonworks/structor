{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 4072,
  "server_mem": 3000,
  "client_mem": 1000,
  "clients" : [ "hdfs", "yarn", "spark" ],
  "nodes": [
    {"hostname": "spark",  "ip": "240.0.0.11", "roles": [ "nn", "yarn", "slave", "client" ]},
    {"hostname": "slave1", "ip": "240.0.0.12", "roles": [ "slave", "client" ]},
    {"hostname": "slave2", "ip": "240.0.0.13", "roles": [ "slave", "client" ]}
  ]
}
