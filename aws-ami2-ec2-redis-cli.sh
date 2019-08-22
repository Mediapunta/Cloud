#!/bin/bash

sudo yum install gcc -y

wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable

make MALLOC=libc

###  To compile against jemalloc, use this
# make MALLOC=jemalloc

sudo cp src/redis-cli /usr/local/bin/
sudo chmod 755 /usr/local/bin/redis-cli
