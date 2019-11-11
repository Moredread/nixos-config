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
        "config"
        "dialout"
        "disk"
        "docker"
        "git"
        "libvirtd"
        "networkmanager"
        "sabnzbd"
        "plugdev"
        "scanner"
        "systemd-journal"
        "tracing"
        "transmission"
        "tty"
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
    config = { gid = 500; };
    plugdev = {};
  };
}
