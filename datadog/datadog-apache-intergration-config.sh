#!/bin/bash 

## ExtendedStatus Configure / ExtendStatus ON 
fileName="/etc/httpd/conf/httpd.conf" 
sed -i '$ a\ExtendedStatus On' $fileName 
sed -i '$ a\\' $fileName 
sed -i '$ a\<Location /server-status>' $fileName 
sed -i '$ a\  SetHandler server-status' $fileName 
sed -i '$ a\  Order deny,allow' $fileName 
sed -i '$ a\  Deny from all' $fileName 
sed -i '$ a\  Allow from localhost' $fileName 
sed -i '$ a\</Location>' $fileName 

## Datadog-agent Configure / Apache의 Metric을 수집하도록 conf파일을 설정 
cp /etc/datadog-agent/conf.d/apache.d/conf.yaml.example /etc/datadog-agent/conf.d/apache.d/conf.yaml 

## Apache 서비스 재 시작 
service httpd restart 

## Datadog-agent 시작 
STATUS=`sudo initctl status datadog-agent` 
if [[ "$STATUS" == *"datadog-agent start/running"* ]] 
then 
echo "Agent already running" 
else 
echo "Agent starting..." 
sudo initctl start datadog-agent 
fi
