# proxy 서버
yum install -y squid

vi /etc/squid/squid.conf
```
# Recommended minimum Access Permission configuration:
#
# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost

# And finally deny all other access to this proxy
#http_access deny all

# Squid normally listens to port 3128
#http_port 3128

#Configure hostname
visible_hostname squid

#Handling HTTP requests
http_port 3129

# Insert your own Rules here to allow access from your clients
acl white_urls dstdomain "/etc/squid/whitelist_site.acl"
http_access allow white_urls

# And finally deny all other access to this proxy
http_access deny all
#http_access allow all

logformat combined %>a %ui %un [%{%d/%b/%Y:%H:%M:%S +0000}tl] "%rm %ru HTTP/%rv" %<Hs %<st "%{Referer}>h" "%{User-Agent}>h" %Ss:%Sh
access_log /var/log/squid/access.log combined
```

vim /etc/squid/whitelist_site.acl
```
# whitelist_site.acl
.datadoghq.com
```


systemctl restart squid

sudo -u dd-agent cp /etc/datadog-agent/conf.d/squid.d/conf.yaml.example /etc/datadog-agent/conf.d/squid.d/conf.yaml

vim /etc/datadog-agent/conf.d/squid.d/conf.yaml
```
instanes:
  - name: 
  port: 3129  
# 기본 포트 : 3128 에서 3129로 세팅하였으니 변경 

```

```
/var/log/squid/access.log
1581303742.596    823 172.x.x.x TCP_MISS/200 5758 CONNECT app.datadoghq.com:443 - HIER_DIRECT/54.208.252.45 -
1581303790.323    931 172.16.x.x TCP_MISS/200 5758 CONNECT app.datadoghq.com:443 - HIER_DIRECT/54.208.252.45 -
1581307342.661    894 172.16.x.x TCP_MISS/200 5758 CONNECT app.datadoghq.com:443 - HIER_DIRECT/34.197.177.186 -
1581307390.235    842 172.16.x.x TCP_MISS/200 5758 CONNECT app.datadoghq.com:443 - HIER_DIRECT/34.197.177.186 -
172.16.x.x - - [10/Feb/2020:13:29:27 +0000] "CONNECT process.datadoghq.com:443 HTTP/1.1" - 32727 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
172.16.x.x - - [10/Feb/2020:13:29:27 +0000] "CONNECT 7-16-1-app.agent.datadoghq.com:443 HTTP/1.1" - 14418 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
172.16.x.x - - [10/Feb/2020:13:29:28 +0000] "CONNECT 7-16-1-app.agent.datadoghq.com:443 HTTP/1.1" - 5425 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
172.16.x.x - - [10/Feb/2020:13:29:29 +0000] "CONNECT app.datadoghq.com:443 HTTP/1.1" - 5758 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
172.16.x.x - - [10/Feb/2020:13:40:33 +0000] "CONNECT process.datadoghq.com:443 HTTP/1.1" - 108516 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
172.16.x.x - - [10/Feb/2020:13:40:33 +0000] "CONNECT 7-16-1-app.agent.datadoghq.com:443 HTTP/1.1" - 40313 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
172.16.x.x - - [10/Feb/2020:13:40:34 +0000] "CONNECT 7-16-1-app.agent.datadoghq.com:443 HTTP/1.1" - 5425 "-" "Go-http-client/1.1" TCP_MISS:HIER_DIRECT
```


아파치 상태 페이지 질의 경로
데이터를 포워딩 
http://localhost/server-status?auto

# Agent Log 상에서 해당 내용 보임
```
2020-02-10 13:52:44 KST | CORE | ERROR | (pkg/collector/runner/runner.go:292 in work) | Error running check apache: [{"message": "503 Server Error: Service Unavailable for url: http://localhost/server-status?auto", "traceback": "Traceback (most recent call last):\n  File \"/opt/datadog-agent/embedded/lib/python3.7/site-packages/datadog_checks/base/checks/base.py\", line 678, in run\n    self.check(instance)\n  File \"/opt/datadog-agent/embedded/lib/python3.7/site-packages/datadog_checks/apache/apache.py\", line 67, in check\n    r.raise_for_status()\n  File \"/opt/datadog-agent/embedded/lib/python3.7/site-packages/requests/models.py\", line 940, in raise_for_status\n    raise HTTPError(http_error_msg, response=self)\nrequests.exceptions.HTTPError: 503 Server Error: Service Unavailable for url: http://localhost/server-status?auto\n"
```

```
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
```

## Datadog-agent Configure / Apache의 Metric을 수집하도록 conf파일을 설정 
cp /etc/datadog-agent/conf.d/apache.d/conf.yaml.example /etc/datadog-agent/conf.d/apache.d/conf.yaml 



white list 적용 후 발생하는 agent log
```
-02-10 14:10:31 KST | CORE | INFO | (pkg/serializer/serializer.go:283 in SendMetadata) | Sent metadata payload, size (raw/compressed): 1556/689 bytes.
2020-02-10 14:10:31 KST | CORE | INFO | (pkg/serializer/serializer.go:303 in SendJSONToV1Intake) | Sent processes metadata payload, size: 1356 bytes.
2020-02-10 14:10:33 KST | CORE | INFO | (pkg/metadata/host/host.go:161 in getNetworkMeta) | could not get network metadata: could not detect network ID
2020-02-10 14:10:33 KST | CORE | INFO | (pkg/serializer/serializer.go:283 in SendMetadata) | Sent metadata payload, size (raw/compressed): 3675/1661 bytes.
```

/etc/datadog-agent/datadog.yaml
```
proxy:
  http: http://proxy-server:3129
  https: http://proxy-server:3129
tags:
#  - env:dev
  - services:test
process_config:
  enabled: true
apm_config:
  enabled: true
#logs_enabled: true
``

# Squid Integration
/etc/datadog-agent/conf.d/squid.d/conf.yaml

sudo -u dd-agent cp /etc/datadog-agent/conf.d/squid.d/conf.yaml.example /etc/datadog-agent/conf.d/squid.d/conf.yaml

## <jboss_wildfly.d>
sudo -u dd-agent cp /etc/datadog-agent/conf.d/jboss_wildfly.d/conf.yaml.example /etc/datadog-agent/conf.d/jboss_wildfly.d/conf.yaml 


## <PostgresSQL>
sudo -u dd-agent cp /etc/datadog-agent/conf.d/postgres.d/conf.yaml.example /etc/datadog-agent/conf.d/postgres.d/conf.yaml 
```
edb-postgres
```

sudo -u dd-agent cp /etc/datadog-agent/datadog.yaml.example /etc/datadog-agent/datadog.yaml 




