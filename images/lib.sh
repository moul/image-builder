# Declares helpers for image building

set -e
[ "$DEBUG" = "1" ] && set -x


prepare_nbd_volume() {
    device=$1
    if ! `mountpoint -q "$TARGET"`; then
	sudo mkfs.ext4 "$device"
	sudo mkdir -p "$TARGET"
	sudo mount "$device" "$TARGET"
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

secondstage() {
    # This step could be done directly by removing 
    sudo chroot "$TARGET" /debootstrap/debootstrap --second-stage
}

patch_target() {
    patches_dir=$1
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
    echo apt-get clean | sudo chroot "$TARGET"
}

archive_target() {
    sudo tar -C "$TARGET" -czf "$NAME.tar.gz" .
}

cli() {
    case $1 in
	"tarball")
	    build_image
	    archive_target
	    exit 0
	    ;;
	"image")
	    NBD_DEVICE=$2
	    prepare_nbd_volume $NBD_DEVICE
	    build_image
	    exit 0
	    ;;
    esac
    echo >&2 "usage: [DEBUG=1] $0 (tarball|image)"
    exit 1
}
