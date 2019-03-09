#!/bin/bash
## <Node.js> 
## APM 설정 활성화 
sed -i 's/# apm_config:.*/apm_config:/' /etc/datadog-agent/datadog.yaml 
sed -i 's/#   enabled: true/  enabled: true/' /etc/datadog-agent/datadog.yaml 
sed -i 's/#   env: none/  env: node.js/' /etc/datadog-agent/datadog.yaml 

## node.js 애플리케이션이 위치하는 디렉터리로 이동 후 라이브러리 설치 
## npm을 사용하여 Datadog Tracing 라이브러리를 설치 
npm install --save dd-trace 

## dd-trace가 데이터 수집 할 수 있게 애플리케이션 소스의 맨 위에 아래의 코드 입력 
const tracer = require('dd-trace').init() 

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
