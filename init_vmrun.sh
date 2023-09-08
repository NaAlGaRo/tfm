#!/bin/bash
echo "user-data" > /home/ubuntu/userdatacheck.txt

sudo apt-get update -y
sudo apt-get install -y nginx > /tmp/nginx.log
sudo service nginx start
