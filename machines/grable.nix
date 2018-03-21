{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../configs/base.nix
      ../configs/emby.nix
      ../configs/unifi.nix
      ../configs/sabnzbd.nix
      ../configs/users-and-groups.nix
      ./hardware-grable.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "grable";
  networking.hostId = "1a9f9479";

  hardware.bumblebee.enable = true;

  i18n.consoleKeyMap = "de";

  services = {
    xserver = {
      videoDrivers = [ "intel" ];
      deviceSection = ''
        Option "DRI" "3"
        Option "AccelMethod" "sna"
        Option "TearFree" "true"
      '';
      useGlamor = true;
      layout = "de";
    };

    tlp.enable = true;
  };
}
