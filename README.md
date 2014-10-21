Online Labs - Image Builder
===========================

Scripts used to build the official images on http://labs.online.net/

- [Images definitions](images)
- [Topic on community.cloud.online.net](https://community.cloud.online.net/t/official-new-linux-distributions-debian-coreos-centos-fedora-arch-linux/229/2)

Examples
--------

Build a **tarball** of **ubuntu-trusty**

    cd images/ubuntu-trusty
    ./build tarball

---

Build a disk **image** of **debian-wheezy**

- Be sure to have a /dev/nbd1 device attached (WARNING, everything will be deleted)
- Run: `cd images/debian-wheezy; ./build image /dev/nbd1`
- If everything is OK, run `sync; halt`
- Powerof your server from the console
- Create a snapshot of /dev/nbd1
- Try to boot from your snapshot or create a new image from your snapshot

Develop a new image
-------------------

- Copy the closest existing image
- Adapt things you are sure
- Run a first `DEBUG=1 ./build image`
- If you have errors, you need to investigate and fix your script
- If you just want to give a try or do some checks before, the working directory is mounted in `rootfs-target`, you can inspect, chroot, etc
