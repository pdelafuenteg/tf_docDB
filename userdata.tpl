#!/bin/bash

# install web server
yum install httpd -y
echo "Hi from ec2 ${ec2_index}" >> /var/www/html/index.html
service httpd start
chkconfig httpd on

# install Mongo console
echo -e "[mongodb-org-3.6] \nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.6/x86_64/\ngpgcheck=1 \nenabled=1 \ngpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" | sudo tee /etc/yum.repos.d/mongodb-org-3.6.repo 
sudo yum install -y mongodb-org-shell
cd /tmp
sudo wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem