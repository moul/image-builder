Online Labs - Image Builder
===========================

Scripts used to build the official images on http://labs.online.net/

- [Images definitions](images)
- [Topic on community.cloud.online.net](https://community.cloud.online.net/t/official-new-linux-distributions-debian-coreos-centos-fedora-arch-linux/229?u=manfred)

Examples
--------

Build a **tarball** of **ubuntu-trusty**

    cd images/ubuntu-trusty
    make rootfs.tar

---

Build a disk **image** of **debian-wheezy**

- Be sure to have a /dev/nbd1 device attached (WARNING, everything will be deleted)
- Run: `cd images/debian-wheezy; make install_on_disk`
- If everything is OK, run `sync; halt`
- Powerof your server from the console
- Create a snapshot of /dev/nbd1
- Try to boot from your snapshot or create a new image from your snapshot

Image check list
----------------

List of features, scripts and modifications to check for proper labs.online.net image creation.

- Add sysctl entry `vm.min_free_kbytes=65536`
- Configure NTP to use internal server.
- Configure SSH to only accept login through public keys and deny environment customization to avoid errors due to users locale.
- Configure default locale to `en_US.UTF-8`.
- Configure network scripts to use DHCP and enable them.
  Although not, strictly speaking, needed since kernel already has IP address and gateway this allows DHCP hooks to be called for setting hostname, etc.
- Install custom DHCP hook for hostname to set entry in `/etc/hosts` for software using `getent_r` to get hostname.
- Install scripts to fetch SSH keys
- Install scripts to fetch kernel modules.
- Install scripts to connect and/or mount NBD volumes.
- Install scripts to manage NBD root volume.
- Disable all physical TTY initialization.
- Enable STTY @ 9600 bps.

Before making the image public, do not forget to check it boots, stops and restarts from the OS without any error (most notably kernel) since a failure could lead to deadlocked instances.
