#!/bin/bash

# Don't touch the user's keyring, have our own instead
export GNUPGHOME=/home/mirrorkeyring
MIRRORDIR=/mnt/mirrors/ubuntumirror
DEBMLOG=/var/log/debmirror.log
if test -s $DEBMLOG
then
test -f $DEBMLOG.3.gz && mv $DEBMLOG.3.gz $DEBMLOG.4.gz
test -f $DEBMLOG.2.gz && mv $DEBMLOG.2.gz $DEBMLOG.3.gz
test -f $DEBMLOG.1.gz && mv $DEBMLOG.1.gz $DEBMLOG.2.gz
test -f $DEBMLOG.0 && mv $DEBMLOG.0 $DEBMLOG.1 && gzip $DEBMLOG.1
mv $DEBMLOG $DEBMLOG.0
cp /dev/null $DEBMLOG
chmod 640 $DEBMLOG
fi

# Ubuntu
echo "\n*** Ubuntu general ***\n" 2>&1 | tee -a $DEBMLOG
debmirror --nosource --method=http --md5sums --progress \
--host=se.archive.ubuntu.com \
--root=/ubuntu \
--dist=precise,precise-security,precise-updates,precise-backports \
--section=main,restricted,universe,multiverse \
--arch=amd64 \
$MIRRORDIR/ubuntu \
2>&1 | tee -a $DEBMLOG

# The --nosource option only downloads debs and not deb-src's
# The --progress option shows files as they are downloaded
# --source \ in the place of --no-source \ if you want sources also.
