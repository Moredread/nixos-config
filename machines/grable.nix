{ config, pkgs, lib, ... }:

let
  nur-no-pkgs = import /home/addy/nur/default.nix {};
in {
  imports =
    [
      ../configs/base.nix
      #../configs/emby.nix
      #../configs/unifi.nix
      #../configs/sabnzbd.nix
      ../configs/users-and-groups.nix
      ./hardware-grable.nix
      nur-no-pkgs.modules.lenovo-throttling-fix
    ];

  services.lenovo-throttling-fix.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  environment.systemPackages = [ pkgs.wireguard ];

  networking.hostName = "grable";
  networking.hostId = "1a9f9478";

  powerManagement.powertop.enable = true;

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
      layout = "en_US";
    };

    #tlp.enable = true;
  };
}
