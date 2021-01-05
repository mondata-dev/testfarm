#!/bin/sh

DATADIR=`pwd`/data
SCRIPTDIR=`pwd`/scripts

cd terraform
cd `terraform output volume_base_dir | tr -d '""'`

backup_dir()
{
  CONTAINER_NAME=$1
  DIR_NAME=$2

  VOL_NAME=$CONTAINER_NAME-$DIR_NAME

  docker stop $CONTAINER_NAME

  sudo tar czf $VOL_NAME.tar.gz $VOL_NAME
  sudo chown $USER:$USER $VOL_NAME.tar.gz
  mv $VOL_NAME.tar.gz $DATADIR/
}

# backup mysql
backup_dir testfarm-mysql store

# backup wordpress instances
for INSTANCE_NAME in `$SCRIPTDIR/instances.sh`
do
  backup_dir $INSTANCE_NAME wwwroot
done
