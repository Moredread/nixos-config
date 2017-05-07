{ config, lib, pkgs, ... }:
{
  users.extraUsers = {
    addy = {
      description = "André-Patrick Bubel";
      uid = 1000;
      name = "addy";
      group = "addy";
      shell = pkgs.zsh;
      extraGroups = [
        "adbusers"
        "adm"
        "atd"
        "audio"
        "cdrom"
        "dialout"
        "docker"
        "git"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "scanner"
        "systemd-journal"
        "tracing"
        "transmission"
        "tty"
        "usbmon"
        "usbtmc"
        "vboxusers"
        "video"
        "wheel"
        "wireshark"
      ];
      isNormalUser = true;
      initialPassword = "initialpw";
      # Subordinate user ids that user is allowed to use. They are set into
      # /etc/subuid and are used by newuidmap for user namespaces. (Needed for
      # LXC.)
      subUidRanges = [
        { startUid = 100000; count = 65536; }
      ];
      subGidRanges = [
        { startGid = 100000; count = 65536; }
      ];

    };
  };

  users.extraGroups = {
    addy = { name = "addy"; };
    plugdev = { gid = 500; };
    tracing = { gid = 501; };
    usbtmc = { gid = 502; };
    wireshark = { gid = 503; };
    usbmon = { gid = 504; };
  };
}
