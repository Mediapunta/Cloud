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
  no_proxy:
    - http://localhost
tags:
#  - env:dev
  - services:test
hostname: Datadog-proxy
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


```
[root@donedb01 postgres.d]# curl 172.16.0.128:3129 -l app.datadoghq.com
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>ERROR: The requested URL could not be retrieved</title>
<style type="text/css"><!--
 /*
 Stylesheet for Squid Error pages
 Adapted from design by Free CSS Templates
 http://www.freecsstemplates.org
 Released for free under a Creative Commons Attribution 2.5 License
*/

/* Page basics */
* {
        font-family: verdana, sans-serif;
}

html body {
        margin: 0;
        padding: 0;
        background: #efefef;
        font-size: 12px;
        color: #1e1e1e;
}

/* Page displayed title area */
#titles {
        margin-left: 15px;
        padding: 10px;
        padding-left: 100px;
        background: url('http://www.squid-cache.org/Artwork/SN.png') no-repeat left;
}

/* initial title */
#titles h1 {
        color: #000000;
}
#titles h2 {
        color: #000000;
}

/* special event: FTP success page titles */
#titles ftpsuccess {
        background-color:#00ff00;
        width:100%;
}

/* Page displayed body content area */
#content {
        padding: 10px;
        background: #ffffff;
}

/* General text */
p {
}

/* error brief description */
#error p {
}

/* some data which may have caused the problem */
#data {
}

/* the error message received from the system or other software */
#sysmsg {
}

pre {
    font-family:sans-serif;
}

/* special event: FTP / Gopher directory listing */
#dirmsg {
    font-family: courier;
    color: black;
    font-size: 10pt;
}
#dirlisting {
    margin-left: 2%;
    margin-right: 2%;
}
#dirlisting tr.entry td.icon,td.filename,td.size,td.date {
    border-bottom: groove;
}
#dirlisting td.size {
    width: 50px;
    text-align: right;
    padding-right: 5px;
}

/* horizontal lines */
hr {
        margin: 0;
}

/* page displayed footer area */
#footer {
        font-size: 9px;
        padding-left: 10px;
}


body
:lang(fa) { direction: rtl; font-size: 100%; font-family: Tahoma, Roya, sans-serif; float: right; }
:lang(he) { direction: rtl; }
 --></style>
</head><body id=ERR_INVALID_URL>
<div id="titles">
<h1>ERROR</h1>
<h2>The requested URL could not be retrieved</h2>
</div>
<hr>

<div id="content">
<p>The following error was encountered while trying to retrieve the URL: <a href="/">/</a></p>

<blockquote id="error">
<p><b>Invalid URL</b></p>
</blockquote>

<p>Some aspect of the requested URL is incorrect.</p>

<p>Some possible problems are:</p>
<ul>
<li><p>Missing or incorrect access protocol (should be <q>http://</q> or similar)</p></li>
<li><p>Missing hostname</p></li>
<li><p>Illegal double-escape in the URL-Path</p></li>
<li><p>Illegal character in hostname; underscores are not allowed.</p></li>
</ul>

<p>Your cache administrator is <a href="mailto:root?subject=CacheErrorInfo%20-%20ERR_INVALID_URL&amp;body=CacheHost%3A%20squid%0D%0AErrPage%3A%20ERR_INVALID_URL%0D%0AErr%3A%20%5Bnone%5D%0D%0ATimeStamp%3A%20Mon,%2010%20Feb%202020%2007%3A30%3A58%20GMT%0D%0A%0D%0AClientIP%3A%20172.16.2.11%0D%0A%0D%0AHTTP%20Request%3A%0D%0A%0D%0A%0D%0A">root</a>.</p>
<br>
</div>

<hr>
<div id="footer">
<p>Generated Mon, 10 Feb 2020 07:30:58 GMT by squid (squid/3.3.8)</p>
<!-- ERR_INVALID_URL -->
</div>
</body></html>
curl: (6) Could not resolve host: app.datadoghq.com; Name or service not known
```



