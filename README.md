# Structor
=======

Vagrant files for standing up clusters on various OSs.

## Modify the cluster

In VagrantFile, change the list of machines to match what you need. The common
control knobs are in this file. In particular,

* nodes - a list of virtual machines to create
* security - a boolean for whether kerberos is enabled
* vm_memory - the amount of memory for each vm
* install_hive - a boolean controlling whether the hive client is installed
* install_pig - a boolean controlling whether pig is installed

For each host in nodes, you define the name, ip address, and the roles for 
that node. The available roles are:

* client - client machine
* kdc - kerberos kdc
* nn - HDFS NameNode
* jt - MapReduce JobTracker
* slave - HDFS DataNode & MapReduce TaskTracker
* hive-db - Hive MetaStore backing mysql
* hive-meta - Hive MetaStore

## Bring up the cluster

Use "vagrant up" to bring up the cluster. This will take 20 to 30 minutes for 
a 4 node cluster.

Use "vagrant ssh gw" to login to the gateway machine. If you configured 
security, you'll need to kinit before you run any hadoop commands.

## Set up on Mac

### Add host names

in /etc/hosts:
```
240.0.0.10 gw.example.com
240.0.0.11 nn.example.com
240.0.0.12 slave1.example.com
240.0.0.13 slave2.example.com
240.0.0.14 slave3.example.com
```

### Install MacPorts Kerberos

Use MacPorts to install kerberos5. I find it works more reliably than Apple's 
built in kerberos. 

### Set up Kerberos (for security)

in /etc/krb5.conf:
```
[logging]
  default = FILE:/var/log/krb5libs.log
  kdc = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log

[libdefaults]
  default_realm = EXAMPLE.COM
  dns_lookup_realm = false
  dns_lookup_kdc = false
  ticket_lifetime = 24h
  renew_lifetime = 7d
  forwardable = true
  udp_preference_limit = 1

[realms]
  EXAMPLE.COM = {
    kdc = nn.example.com
    admin_server = nn.example.com
  }

[domain_realm]
  .example.com = EXAMPLE.COM
  example.com = EXAMPLE.COM
```

You should be able to kinit to your new domain (user: vagrant and 
password: vagrant):

```
% kinit vagrant@EXAMPLE.COM
```

### Set up browser (for security)

Do a kinit in a terminal.

Safari should just work.

Firefox go to "about:config" and set "network.negotiate-auth.trusted-uris" to 
".example.com".

Chrome needs command line parameters on every start and is not recommended.