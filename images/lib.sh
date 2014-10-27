# Declares helpers for image building

set -e
[ "$DEBUG" = "1" ] && set -x


prepare_nbd_volume() {
    device=$1
    if ! `mountpoint -q "$TARGET"`; then
	sudo mkfs.ext4 "$device"
	sudo mkdir -p "$TARGET.device"
	sudo mount "$device" "$TARGET.device"
	rsync -aHAX "$TARGET/" "$TARGET.device"
    fi
}

require_debootstrap() {
    type -P debootstrap >/dev/null && return
    sudo apt-get update
    sudo apt-get -y install debootstrap
}

clean_workspace() {
    sudo rm -rf $TARGET/* $TARGET/.??*
}

debootstrap() {
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

upgrade_debs() {
    do_in_target apt-get update
    do_in_target apt-get -y upgrade
}

secondstage() {
    # This step could be done directly by removing 
    sudo chroot "$TARGET" /debootstrap/debootstrap --second-stage
}

patch_target() {
    patches_dir=../$1
    for file in $(find "$patches_dir" -type f | sed -n "s|^$patches_dir/||p"); do
	sudo mkdir -p "$TARGET/$(dirname $file)"
	sudo cp "$patches_dir/$file" "$TARGET/$file"
    done
}

clean_target() {
    clean_paths=$1
    for path in $clean_paths; do
	if [ -e "$TARGET/$path" ]; then
	    sudo rm -rf "$TARGET/$path"
	fi
    done
    for file in $(find "$TARGET/var/log" -type f); do
	echo | sudo tee $file
    done
}

archive_target() {
    sudo tar -C "$TARGET" -czf "$NAME.tar.gz" .
}

do_in_target() {
    sudo chroot "$TARGET" $@
}

push_to_s3() {
    edit_date=$(stat -c %Y "$TARGET")
    s3cmd put --acl-public "$NAME.tar.gz" "$S3_URL/$NAME-${edit_date}.tar.gz"
    s3cmd put --acl-public "$NAME.tar.gz" "$S#_URL/$NAME-latest.tar.gz"
    s3cmd ls "s3://rescue-images/rescue/"
    # s3cmd cp --acl-public "s3://rescue-images/rescue/$NAME-${edit_date}.tar.gz" "s3://rescue-images/rescue/$NAME-latest.tar.gz"
}

cli() {
    case $1 in
	"tarball")
	    build_image
	    patch_image
	    upgrade_image
	    clean_image
	    archive_target
	    push_to_s3
	    exit 0
	    ;;
	"image")
	    NBD_DEVICE=${2:-"/dev/nbd1"}
	    build_image
	    patch_image
	    upgrade_image
	    clean_image
	    prepare_nbd_volume $NBD_DEVICE
	    sync
	    exit 0
	    ;;
	"build_image"|"patch_image"|"archive_target"|"prepare_nbd_volume"|"upgrade_image"|"clean_image"|"push_to_s3")
	    eval $@
	    exit 0
	    ;;
    esac
    echo >&2 "usage: [DEBUG=1] $0 (tarball|image)"
    exit 1
}
