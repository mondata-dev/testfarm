#!/bin/sh

# create new nginx config
cp testfarm-nginx-conf/conf.d/sites-enabled/testfarm-wp-vanilla.conf \
  testfarm-nginx-conf/conf.d/sites-enabled/testfarm-$2.conf
sed -i -e "s/wp-vanilla/$2/g" testfarm-nginx-conf/conf.d/sites-enabled/testfarm-$2.conf

# create new empty backup
mkdir /tmp/testfarm-$2-wwwroot

sudo chown -R 33.33 /tmp/testfarm-$2-wwwroot # www-data
cd /tmp
tar czf $OLDPWD/testfarm-$2-wwwroot.tar.gz testfarm-$2-wwwroot
