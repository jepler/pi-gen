#!/bin/bash -e

install -m 644 files/sources.list "${ROOTFS_DIR}/etc/apt/"
install -m 644 files/raspi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 644 files/linuxcnc.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 644 files/linuxcnc-buildbot.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

if [ -n "$APT_PROXY" ]; then
	install -m 644 files/51cache "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
	sed "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache" -i -e "s|APT_PROXY|${APT_PROXY}|"
else
	rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
fi

echo "APT::Acquire::Retries \"3\";" > "${ROOTFS_DIR}/etc/apt/apt.conf.d/80-retries"

on_chroot apt-key add - < files/raspberrypi.gpg.key
on_chroot apt-key add - < files/linuxcnc.gpg.key
on_chroot apt-key add - < files/linuxcnc-buildbot.gpg.key
on_chroot << EOF
apt-get update
apt-get dist-upgrade -y
EOF
