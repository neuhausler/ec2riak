#!/bin/bash

#
# This script installs and configures riak on a fresh Amazon Linux AMI instance.
#
# Must be run with root privileges
#

PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin

export INSTALL_DIR="$PWD"

# get code and build it
yum -y install gcc gcc-c++ glibc-devel make
wget http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.2/1.2.1/riak-1.2.1.tar.gz
tar zxvf riak-1.2.1.tar.gz
cd riak-1.2.1
make rel

# copy to /usr/local/lib
mkdir -p /usr/local/lib
cp -R rel/riak /usr/local/lib/

# move etc
mkdir -p /usr/local/etc
mv /usr/local/lib/riak/etc /usr/local/etc/riak
ln -s /usr/local/etc/riak /usr/local/lib/riak/etc

# move data
mkdir -p /usr/local/var/lib
mv /usr/local/lib/riak/data /usr/local/var/lib/riak
ln -s /usr/local/var/lib/riak /usr/local/lib/riak/data

# move log
mkdir -p /usr/local/var/log
mv /usr/local/lib/riak/log /usr/local/var/log/riak
ln -s /usr/local/var/log/riak /usr/local/lib/riak/log

# add riak user
adduser --system --home /usr/local/var/lib/riak -M --shell /bin/bash --comment "Riak" riak

# change file ownership
chown -R riak:riak /usr/local/etc/riak /usr/local/var/lib/riak /usr/local/var/log/riak /usr/local/lib/riak

# put changed init.d script in place
cp $INSTALL_DIR/riak.initd /usr/local/etc/rc.d/riak
chmod 0755 /usr/local/etc/rc.d/riak
ln -s /usr/local/etc/rc.d/riak /etc/init.d/riak


# done!
echo
echo
echo "Installation complete!"
echo "Riak is ready to start. Run:"
echo "    sudo service riak start"

