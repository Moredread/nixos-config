
{ config, lib, pkgs, ... }:
{
  services = {
    openssh = {
      enable = true;
      forwardX11 = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    #flatpak.enable = true;

    fwupd.enable = true;
    acpid.enable = true;
    dbus.enable = true;
    locate.enable = true;
    # mkDefault, so that it works with VMs (who set it to false)
    timesyncd.enable = lib.mkDefault true;
    thermald.enable = true;
    pcscd.enable = true;
    trezord.enable = true;

    nixosManual.enable = true;
    nixosManual.showManual = true;

    udev.extraRules = with pkgs; ''
      # Trezor
      SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
      KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

      # set scheduler for non-rotating disks
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="noop"

      # give user permission to change brightness
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"

      # NS PRO Controller USB
      KERNEL=="hidraw*", ATTRS{idVendor}=="20d6", ATTRS{idProduct}=="a711", MODE="0660", TAG+="uaccess", GROUP="input"
    '';

    # cups, for printing documents
    printing.enable = true;
    printing.drivers = with pkgs; [ gutenprint hplip ];

    avahi = {
      enable = true;
      nssmdns = true;
      ipv6 = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "addy";
      dataDir = "/home/addy/.config/syncthing";
    };

    xserver = {
      enable = true;

      libinput.enable = true;
      desktopManager.xterm.enable = false;
      xkbOptions = "ctrl:nocaps";

      useGlamor = true;
      displayManager.sessionCommands = '''';
      displayManager.slim = {
        enable = true;
        autoLogin  = true;
        defaultUser = "addy";
      };

      inputClassSections = [
        ''
          Identifier "BT mouse"
          MatchDriver "libinput"
          MatchProduct "BM30X mouse"
          Option "AccelSpeed" "-0.5"
        ''
      ];
    };

    dbus.packages = [ pkgs.blueman ];
  };
}
