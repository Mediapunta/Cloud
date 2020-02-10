## Private에 있는 서버들과 DatadogHQ간 연결을 위하여 DMZ존에 Proxy를 구성하여 연결 합니다.

#squid 패키지 다운로드 
wget http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.28.tar.gz
tar -zvxf squid-3.5.28.tar.gz
cd squid-3.5.28/

sudo ./configure --prefix=/usr --exec-prefix=/usr --libexecdir=/usr/lib64/squid --sysconfdir=/etc/squid --sharedstatedir=/var/lib --localstatedir=/var --libdir=/usr/lib64 --datadir=/usr/share/squid --with-logdir=/var/log/squid --with-pidfile=/var/run/squid.pid --with-default-user=squid --disable-dependency-tracking --enable-linux-netfilter --with-openssl --without-nettle --disable-arch-native

sudo make; make install

sudo adduser -M squid
sudo chown -R squid:squid /var/log/squid /var/cache/squid
sudo chmod 750 /var/log/squid /var/cache/squid
sudo touch /etc/squid/squid.conf
sudo chown -R root:squid /etc/squid/squid.conf
sudo chmod 640 /etc/squid/squid.conf
cat | sudo tee /etc/init.d/squid <<'EOF'
#!/bin/sh
# chkconfig: - 90 25
echo -n 'Squid service'
case "$1" in
start)
/usr/sbin/squid
;;
stop)
/usr/sbin/squid -k shutdown
;;
reload)
/usr/sbin/squid -k reconfigure
;;
*)
echo "Usage: `basename $0` {start|stop|reload}"
;;
esac
EOF
sudo chmod +x /etc/init.d/squid
sudo chkconfig squid on

sudo mkdir /etc/squid/ssl
cd /etc/squid/ssl
sudo openssl genrsa -out squid.key 2048
sudo openssl req -new -key squid.key -out squid.csr -subj "/C=XX/ST=XX/L=squid/O=squid/CN=squid"
sudo openssl x509 -req -days 3650 -in squid.csr -signkey squid.key -out squid.crt
sudo cat squid.key squid.crt | sudo tee squid.pem

cat | sudo tee /etc/squid/squid.conf <<EOF
visible_hostname squid

#Handling HTTP requests
http_port 3129
http_access allow all
