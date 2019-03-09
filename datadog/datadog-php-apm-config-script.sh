#!/bin/bash
## <PHP> 
## APM 설정 활성화 
sed -i 's/# apm_config:.*/apm_config:/' /etc/datadog-agent/datadog.yaml 
sed -i 's/#   enabled: true/  enabled: true/' /etc/datadog-agent/datadog.yaml 
sed -i 's/#   env: none/  env: php/' /etc/datadog-agent/datadog.yaml 

## dd-trace 다운 후 rpm파일 설치 
wget https://github.com/DataDog/dd-trace-php/releases/download/0.13.0/datadog-php-tracer-0.13.0_beta-1.x86_64.rpm 
sudo rpm -ivh ~/datadog-php-tracer-0.13.0_beta-1.x86_64.rpm 

## datadog agent 시작 
STATUS=`sudo initctl status datadog-agent` 
if [[ "$STATUS" == *"datadog-agent start/running"* ]] 
then 
echo "Agent already running" 
else 
echo "Agent starting..." 
sudo initctl start datadog-agent 
fi 

## 애플리케이션 재시작 
service httpd restart 
