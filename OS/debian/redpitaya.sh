################################################################################
# Authors:
# - Pavel Demin <pavel.demin@uclouvain.be>
# - Iztok Jeras <iztok.jeras@redpitaya.com>
# License:
# https://raw.githubusercontent.com/RedPitaya/RedPitaya/master/COPYING
################################################################################

# Copy files to the boot file system
unzip ecosystem*.zip -d $BOOT_DIR
cp -f $BOOT_DIR/u-boot.scr.debian $BOOT_DIR/u-boot.scr

# Nginx service
install -v -m 664 -o root -d                                                         $ROOT_DIR/var/log/redpitaya_nginx
install -v -m 664 -o root -D $OVERLAY/etc/systemd/system/redpitaya_discovery.service $ROOT_DIR/etc/systemd/system/redpitaya_discovery.service
install -v -m 664 -o root -D $OVERLAY/etc/systemd/system/redpitaya_nginx.service     $ROOT_DIR/etc/systemd/system/redpitaya_nginx.service
install -v -m 664 -o root -D $OVERLAY/etc/systemd/system/redpitaya_scpi.service      $ROOT_DIR/etc/systemd/system/redpitaya_scpi.service
install -v -m 664 -o root -D $OVERLAY/etc/sysconfig/redpitaya                        $ROOT_DIR/etc/sysconfig/redpitaya

chroot $ROOT_DIR <<- EOF_CHROOT
systemctl enable redpitaya_discovery
systemctl enable redpitaya_nginx
#systemctl enable redpitaya_scpi

apt-get -y install libluajit-5.1 lua-cjson unzip
apt-get -y install libboost-system1.55.0 libboost-regex1.55.0 libboost-thread1.55.0
EOF_CHROOT

# final operations and cleanup
install -v -m 664 -o root -D $OVERLAY/etc/profile.d/redpitaya.sh $ROOT_DIR/etc/profile.d/redpitaya.sh
