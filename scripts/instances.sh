#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for BACKUP in $SCRIPT_DIR/../data/testfarm-*-wwwroot.tar.gz;
do
  echo `basename $BACKUP -wwwroot.tar.gz`
done
