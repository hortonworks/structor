#!/bin/bash
mysql -u root -pvagrant << EOF
create user 'root'@'%' identified by 'vagrant';
grant all privileges on *.* to 'root'@'%' with grant option;
EOF
