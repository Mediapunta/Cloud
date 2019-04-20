#!/bin/bash
#nginx 저장소 추가
#[Centos]
echo [nginx] >> /etc/yum.repos.d/nginx.repo
fileName="/etc/yum.repos.d/nginx.repo"

sed -i '$ a\name=nginx repo' $fileName
sed -i '$ a\baseurl=http://nginx.org/packages/centos/$releaserver/$basearch' $fileName
sed -i '$ a\gpgcheck=0' $fileName
sed -i '$ a\enabled=1' $fileName
 
#Nginx 설치
yum --enablerepo=nginx install nginx
service nginx start
chkconfig nginx on
 
#php-fpm 설치
yum install -y php70 php70-fpm php70-mysqlnd
 
sed -i "s/user = apache/user = nginx/" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/" /etc/php-fpm.d/www.conf
service php-fpm start
chkconfig php-fpm on
