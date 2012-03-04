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
wget http://downloads.basho.com/riak/riak-1.1.0/riak-1.1.0.tar.gz
tar zxvf riak-1.1.0.tar.gz
cd riak-1.1.0
make rel

# copy to /usr/local/lib
rm -rf /usr/local/lib/riak
cp -R rel/riak /usr/local/lib/

# move etc
rm -rf /usr/local/etc/riak
mv /usr/local/lib/riak/etc /usr/local/etc/riak
ln -s /usr/local/etc/riak /usr/local/lib/riak/etc

# move data
rm -rf /usr/local/var/lib/riak
mv /usr/local/lib/riak/data /usr/local/var/lib/riak
ln -s /usr/local/var/lib/riak /usr/local/lib/riak/data

# move log
rm -rf /usr/local/var/log/riak
mv /usr/local/lib/riak/log /usr/local/var/log/riak
ln -s /usr/local/var/log/riak /usr/local/lib/riak/log

# add riak user
adduser --system --home /usr/local/var/lib/riak -M --shell /bin/bash --comment "Riak" riak

# change file ownership
chown -R riak:riak /usr/local/etc/riak /usr/local/var/lib/riak /usr/local/var/log/riak /usr/local/lib/riak

# put changed init.d script in place
cp $INSTALL_DIR/riak.initd /usr/local/etc/rc.d/
chmod 0755 /usr/local/etc/rc.d/riak
ln -s /usr/local/etc/rc.d/riak /etc/init.d/riak


# done!
echo
echo
echo "Installation complete!"
echo "Riak is ready to start. Run:"
echo "    sudo service riak start"

