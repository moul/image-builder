#!/bin/bash

set -e
[ "$DEBUG" = "1" ] && set -x

DISTRIB="ubuntu"
ARCH="armhf"
VARIANT="minbase"
COMPONENTS="main,universe"
PKGS_INCLUDE="ca-certificates,cron,curl,iptables,iputils-ping,isc-dhcp-client,less,man-db,nano,nbd-client,net-tools,ntp,ntpdate,rsyslog,ssh,sudo,wget,whiptail,xnbd-client"
MIRROR="http://mirror.cloud.online.net/ubuntu-ports/"
VERSION="trusty"
TARGET=${TARGET:-rootfs-target}
CLEAN_PATHS="/root/.bash_history /root/.history /etc/resolv.conf /etc/hostname"
SCRIPT=""
NAME="rootfs-$ARCH-$DISTRIB-$VERSION"

prepare_nbd_volume() {
    DEVICE=$1
    if [ ! $(mountpoint -q "$TARGET") ]; then
	sudo mkfs.ext4 "$DEVICE"
	sudo mkdir -p "$TARGET"
	sudo mount "$DEVICE" "$TARGET"
    fi
}

install_requirements() {
    type -P debootstrap >/dev/null && return
    sudo apt-get update
    sudo apt-get -y install debootstrap
}

run_clean_workspace() {
    sudo rm -rf "$TARGET"
}

run_debootstrap() {
    sudo debootstrap \
	--arch="$ARCH" \
	--variant="$VARIANT" \
	--components="$COMPONENTS" \
	--include="$PKGS_INCLUDE" \
	--foreign \
	"$VERSION" \
	"$TARGET" \
	"$MIRROR" \
	"$SCRIPT"
}

run_secondstage() {
    # This step could be done directly by removing 
    sudo chroot "$TARGET" /debootstrap/debootstrap --second-stage
}

run_patch_target() {
    PATCHES_DIR=patches  # without trailing slash
    for file in $(find "$PATCHES_DIR" -type f | sed -n "s|^$PATCHES_DIR/||p"); do
	sudo mkdir -p "$TARGET/$(dirname $file)"
	sudo cp "$PATCHES_DIR/$file" "$TARGET/$file"
    done
}

run_clean_target() {
    for path in $CLEAN_PATHS; do
	if [ -e "$TARGET/$path" ]; then
	    sudo rm -rf "$TARGET/$path"
	fi
    done
    echo apt-get clean | sudo chroot "$TARGET"
}

run_archive_target() {
    sudo tar -C "$TARGET" -czf "$NAME.tar.gz" .
}


main() {
    case $1 in
	"tarball")
	    install_requirements
	    run_clean_workspace
	    run_debootstrap
	    run_secondstage
	    run_patch_target
	    run_clean_target
	    run_archive_target
	    exit 0
	    ;;
	"image")
	    install_requirements
	    prepare_nbd_volume $2
	    run_debootstrap
	    run_secondstage
	    run_patch_target
	    run_clean_target
	    exit 0
	    ;;
    esac
    echo >&2 "usage: $0 [tarball|image]"
    exit 1
}
main $@
