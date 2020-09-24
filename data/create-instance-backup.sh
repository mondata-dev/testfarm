#!/bin/sh

INSTANCE_NAME=$1

# create new nginx config
cp testfarm-nginx-conf/conf.d/sites-enabled/testfarm-wp-vanilla.conf \
  testfarm-nginx-conf/conf.d/sites-enabled/testfarm-$INSTANCE_NAME.conf
sed -i -e "s/wp-vanilla/$INSTANCE_NAME/g" testfarm-nginx-conf/conf.d/sites-enabled/testfarm-$INSTANCE_NAME.conf

# create new empty backup
mkdir /tmp/testfarm-$INSTANCE_NAME-wwwroot

sudo chown -R 33.33 /tmp/testfarm-$INSTANCE_NAME-wwwroot # www-data
cd /tmp
tar czf $OLDPWD/testfarm-$INSTANCE_NAME-wwwroot.tar.gz testfarm-$INSTANCE_NAME-wwwroot
