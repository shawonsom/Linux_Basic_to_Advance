#!/bin/bash
TODAY=$(date +%Y-%m-%d)
DATADIR=/ismp/test
DATADIR1=/var/www/
DATADIR2=/etc
DATADIR3=/home/database_backup
BACKUPDIR=/NAS/Mybackup/BLink-22
TODAYPATH=${BACKUPDIR}/${TODAY}
if [[ ! -e ${TODAYPATH} ]]; then
        mkdir -p ${TODAYPATH}
fi

rsync -aze --link-dest --exclude '*.txt' --exclude 'core.*'  ${DATADIR} ${DATADIR1} ${DATADIR2} ${DATADIR3} ${TODAYPATH}
tar -zcf ${BACKUPDIR}/$TODAY.tar.gz -P ${BACKUPDIR}/$TODAY
rm -rf ${BACKUPDIR}/$TODAY
find /NAS/Mybackup/BLink-22/* -mtime +1 -exec rm {} \;
