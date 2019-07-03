
{ config, lib, pkgs, ... }:
{
  documentation = {
    enable = true;

    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  programs.qt5ct.enable = true;

  hardware.u2f.enable = true;

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
    thermald.enable = true;
    pcscd.enable = true;
    trezord.enable = true;

    # mkDefault, so that it works with VMs (which sets it to false)
    timesyncd.enable = lib.mkDefault true;

    nixosManual.showManual = true;

    udev.extraRules = with pkgs; ''
      # Trezor
      SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
      KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

      # set scheduler for non-rotating disks
      ACTION=="add|change", SUBSYSTEM=="block", DRIVERS=="sd|sr", ATTR{queue/scheduler}!="bfq", ATTR{queue/scheduler}="bfq"

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

      # TODO: Pull the file from Github

      # Copyright (C) 2013-2015 Yubico AB
      #
      # This program is free software; you can redistribute it and/or modify it
      # under the terms of the GNU Lesser General Public License as published by
      # the Free Software Foundation; either version 2.1, or (at your option)
      # any later version.
      #
      # This program is distributed in the hope that it will be useful, but
      # WITHOUT ANY WARRANTY; without even the implied warranty of
      # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
      # General Public License for more details.
      #
      # You should have received a copy of the GNU Lesser General Public License
      # along with this program; if not, see <http://www.gnu.org/licenses/>.

      # this udev file should be used with udev 188 and newer
      ACTION!="add|change", GOTO="u2f_end"

      # Yubico YubiKey
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0200|0402|0403|0406|0407|0410", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Happlink (formerly Plug-Up) Security KEY
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="f1d0", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Neowave Keydo and Keydo AES
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1e0d", ATTRS{idProduct}=="f1d0|f1ae", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # HyperSecu HyperFIDO, KeyID U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e|2ccf", ATTRS{idProduct}=="0880", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Feitian ePass FIDO, BioPass FIDO2, KeyID U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0850|0852|0853|0854|0856|0858|085a|085b|085d", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # JaCarta U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="24dc", ATTRS{idProduct}=="0101|0501", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # U2F Zero
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="8acf", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # VASCO SeccureClick
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1a44", ATTRS{idProduct}=="00bb", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Bluink Key
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2abe", ATTRS{idProduct}=="1002", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Thetis Key
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ea8", ATTRS{idProduct}=="f025", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Nitrokey FIDO U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="4287", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Google Titan U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="5026", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Tomu board + chopstx U2F + SoloKeys
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="cdab|a2ca", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # SoloKeys
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5070|50b0", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Trezor
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Ledger Nano S and Nano X
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|0004", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Kensington VeriMark
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="06cb", ATTRS{idProduct}=="0088", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      # Longmai mFIDO
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4c4d", ATTRS{idProduct}=="f703", TAG+="uaccess", GROUP="plugdev", MODE="0660"

      LABEL="u2f_end"
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
