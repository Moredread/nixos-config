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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  environment.systemPackages = [ pkgs.wireguard ];

  networking.hostName = "grable";
  networking.hostId = "1a9f9478";

  #i18n.consoleKeyMap = "en_US";

  nix = {
    buildCores = 8;
    maxJobs = 8;
  };

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
