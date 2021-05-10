{ config, lib, pkgs, ... }:
{
  documentation = {
    #enable = true;

    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    nixos.enable = true;
    man.enable = true;
  };

  programs.qt5ct.enable = true;
  programs.zsh.enable = true;

  services = {
    openssh = {
      enable = true;
      forwardX11 = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    acpid.enable = true;
    colord.enable = true;
    dbus.enable = true;
    flatpak.enable = true;
    blueman.enable = true;
    fwupd.enable = true;
    locate.enable = true;
    pcscd.enable = true;
    thermald.enable = true;
    trezord.enable = true;

    tailscale.enable = true;
    tailscale.package = pkgs.unstable.tailscale;

    # mkDefault, so that it works with VMs (which sets it to false)
    timesyncd.enable = lib.mkDefault true;

    udev.packages = [
      pkgs.logitech-udev-rules
    ];
    udev.extraRules = with pkgs; ''
      # Ultimate Hacking Keyboard rules
      # These are the udev rules for accessing the USB interfaces of the UHK as non-root users.
      # Copy this file to /etc/udev/rules.d and physically reconnect the UHK afterwards.
      SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
      SUBSYSTEMS=="usb",  ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660", TAG+="uaccess"
      KERNEL=="hidraw*",  ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660", TAG+="uaccess"

      SUBSYSTEM=="input", ATTRS{idVendor}=="7504", GROUP="input", MODE="0660"
      SUBSYSTEMS=="usb",  ATTRS{idVendor}=="7504", GROUP="input", MODE="0660", TAG+="uaccess"
      KERNEL=="hidraw*",  ATTRS{idVendor}=="7504", GROUP="input", MODE="0660", TAG+="uaccess"

      # Trezor
      SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
      KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

      # set scheduler for non-rotating disks
      ACTION=="add|change", SUBSYSTEM=="block", DRIVERS=="sd|sr", ATTR{queue/scheduler}!="bfq", ATTR{queue/scheduler}="bfq"

      # give user permission to change brightness
      # TODO: check if hardware options does this
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

      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0660", GROUP="plugdev", TAG+="uaccess"

      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6089", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE="0660", GROUP="plugdev", TAG+="uaccess"

      # ESP32 board
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0660", GROUP="plugdev", TAG+="uaccess"

    '';

    # cups, for printing documents
    printing.enable = true;
    printing.drivers = with pkgs; [ gutenprint hplip cnijfilter2 ];

    avahi = {
      enable = lib.mkDefault true;
      #nssmdns = true;
      ipv6 = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
      openFirewall = true;
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

      useGlamor = lib.mkDefault false;
      displayManager.startx.enable = true;

      inputClassSections = [
        ''
          Identifier "BT mouse"
          MatchDriver "libinput"
          MatchProduct "BM30X mouse"
          Option "AccelSpeed" "-0.5"
        ''
        ''
          Identifier "Anker mouse"
          MatchDriver "libinput"
          MatchProduct "MOSART Semi. 2.4G Wireless Mouse Mouse"
          Option "AccelSpeed" "-0.1"
        ''
      ];
    };

    dbus.packages = with pkgs; [ blueman gnome3.dconf ];

    physlock.enable = true;
    physlock.disableSysRq = true;
    physlock.allowAnyUser = true;
  };
}
