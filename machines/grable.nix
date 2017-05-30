{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../configs/base-desktop.nix
      ../configs/users-and-groups.nix
      ./hardware-grable.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries = ''
    menuentry 'Arch Linux' {
      configfile (hd0,msdos3)/grub/grub.cfg
    }
  '';

  networking.hostName = "grable";

  i18n.consoleKeyMap = "de";

  hardware.bumblebee.enable = true;

  services = {
    xserver.videoDrivers = [ "intel" ];

    tlp.enable = true;
  };
}
