#!/bin/bash

## Nginx의 Metric은 Nginx Status Module을 사용하므로 두개의 Status Module중 한 개의 Module이 컴파일되어 있어야 합니다. 
## - Stub status module 
## - http status module (Nginx Plus Only) 

## nginx status 설정 파일 생성 
echo '## nginx status config' >> /etc/nginx/conf.d/status.conf 
fileName="/etc/nginx/conf.d/status.conf" 

sed -i '$ a\server {' $fileName 
sed -i '$ a\  listen 81;' $fileName 
sed -i '$ a\  server_name localhost;' $fileName 
sed -i '$ a\\' $fileName 
sed -i '$ a\  access_log off;' $fileName 
sed -i '$ a\  allow 127.0.0.1;' $fileName 
sed -i '$ a\  deny all;' $fileName 
sed -i '$ a\\' $fileName 
sed -i '$ a\  location /nginx_status {' $fileName 
sed -i '$ a\    # Choose your status module' $fileName 
sed -i '$ a\\' $fileName 
sed -i '$ a\    # freely available with open source NGINX' $fileName 
sed -i '$ a\    stub_status;' $fileName 
sed -i '$ a\\' $fileName 
sed -i '$ a\    # available only with NGINX Plus' $fileName 
sed -i '$ a\    # status;' $fileName 
sed -i '$ a\  }' $fileName 
sed -i '$ a\}' $fileName 

## Nginx의 Status Module 활성화를 위해 Reload 
sudo service nginx reload 

## Datadog Agent에서 Nginx의 Metric을 수집하도록 conf파일을 설정 
echo 'init_config' >> /etc/datadog-agent/conf.d/nginx.d/conf.yaml 
fileName="/etc/datadog-agent/conf.d/nginx.d/conf.yaml" 
sed -i '$ a\instances:' $fileName 
sed -i '$ a\  - nginx_status_url: http://localhost:81/nginx_status/' $fileName 
sed -i '$ a\  # If you configured the endpoint with HTTP basic authentication' $fileName 
sed -i '$ a\  # user: <USER>' $fileName 
sed -i '$ a\  # password: <PASSWORD>' $fileName 

## Datadog Agent 시작 
STATUS=`sudo initctl status datadog-agent` 
if [[ "$STATUS" == *"datadog-agent start/running"* ]] 
then 
echo "Agent already running" 
else 
echo "Agent starting..." 
sudo initctl start datadog-agent 
fi
