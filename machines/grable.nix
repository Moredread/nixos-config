{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../configs/base-desktop.nix
      ../configs/users-and-groups.nix
      ../hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries = ''
      menuentry 'Arch Linux' {
        configfile (hd0,1)/boot/grub/grub.cfg
        }
  '';

  networking.hostName = "grable";

#  i18n.consoleKeyMap = "de";

  services = {
    xserver.videoDrivers = [ "intel" ];
    xserver.synaptics.enable = true;
    xserver.synaptics.twoFingerScroll = true;
    xserver.layout = "de";
  };
}
