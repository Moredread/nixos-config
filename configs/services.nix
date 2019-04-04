
{ config, lib, pkgs, ... }:
{
  documentation.enable = true;
  documentation.dev.enable = true;
  documentation.doc.enable = true;
  documentation.info.enable = true;
  documentation.nixos.enable = true;

  services = {
    openssh = {
      enable = true;
      forwardX11 = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    flatpak.enable = true;

    fwupd.enable = true;
    acpid.enable = true;
    dbus.enable = true;
    locate.enable = true;
    # mkDefault, so that it works with VMs (which sets it to false)
    timesyncd.enable = lib.mkDefault true;
    thermald.enable = true;
    pcscd.enable = true;
    trezord.enable = true;

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

      # This rule is needed for basic functionality of the controller in Steam and keyboard/mouse emulation
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
      # This rule is necessary for gamepad emulation; make sure you replace 'pgriffais' with a group that the user that runs Steam belongs to
      KERNEL=="uinput", MODE="0660", GROUP="addy", OPTIONS+="static_node=uinput"
      # Valve HID devices over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
      # Valve HID devices over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"
      # DualShock 4 over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
      # DualShock 4 wireless adapter over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
      # DualShock 4 Slim over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
      # DualShock 4 over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
      # DualShock 4 Slim over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"

      # NS PRO Controller USB
      KERNEL=="hidraw*", ATTRS{idVendor}=="20d6", ATTRS{idProduct}=="a711", MODE="0660", TAG+="uaccess", GROUP="input"
      SUBSYSTEMS=="usb", ATTR{idVendor}=="057e", MODE="0666"
    '';

    # cups, for printing documents
    printing.enable = false;
    printing.drivers = with pkgs; [ gutenprint hplip ];

    avahi = {
      enable = false;
      nssmdns = true;
      ipv6 = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
    };

    syncthing = {
      enable = false;
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

    dbus.packages = with pkgs; [ blueman gnome3.dconf ];

    physlock.enable = true;
    physlock.disableSysRq = true;
    physlock.allowAnyUser = true;
  };
}
