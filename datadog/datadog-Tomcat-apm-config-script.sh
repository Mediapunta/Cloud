#!/bin/bash
## <Java> 
## APM 설정 활성화 
sed -i 's/# apm_config:.*/apm_config:/' /etc/datadog-agent/datadog.yaml 
sed -i 's/#   enabled: true/  enabled: true/' /etc/datadog-agent/datadog.yaml 
sed -i 's/#   env: none/  env: java-tomcat/' /etc/datadog-agent/datadog.yaml 

## dd-java-agent.jar 다운로드 
wget -O dd-java-agent.jar 'https://search.maven.org/classic/remote_content?g=com.datadoghq&a=dd-java-agent&v=LATEST' 

## /opt/datadog-agent/ 경로로 파일 이동 
sudo mv dd-java-agent.jar /usr/share/tomcat8/ 

## dd-trace가 데이터 수집할 수 있게 아래 코드 입력 
## java -jar명령 에서 응용 프로그램을 시작할 때 다음 JVM 인수를 추가. 
## -javaagent:/path/to/the/dd-java-agent.jar 
## 테스트의 경우 톰캣을 이용하였으므로 catalina.sh에 입력 

## /usr/share/tomcat8/bin/catalina.sh 에 환경 변수 입력 
export JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/share/tomcat8/dd-java-agent.jar" 

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
cd /usr/share/tomcat8/bin 
sudo ./shutdown.sh 
sudo ./startup.sh 
