# Image check list

List of features, scripts and modifications to check for proper labs.online.net image creation.

* Add sysctl entry `vm.min_free_kbytes=65536`
* Configure NTP to use internal server.
* Configure SSH to only accept login through public keys and deny environment customization to avoid errors due to users locale.
* Configure default locale to `en_US.UTF-8`.
* Configure network scripts to use DHCP and enable them.
  Although not, strictly speaking, needed since kernel already has IP address and gateway this allows DHCP hooks to be called for setting hostname, etc.
* Install custom DHCP hook for hostname to set entry in `/etc/hosts` for software using `getent_r` to get hostname.
* Install scripts to fetch SSH keys
* Install scripts to fetch kernel modules.
* Install scripts to connect and/or mount NBD volumes.
* Install scripts to manage NBD root volume.
* Disable all physical TTY initialization.
* Enable STTY @ 9600 bps.

Before making the image public, do not forget to check it boots, stops and restarts from the OS without any error (most notably kernel) since a failure could lead to deadlocked instances.