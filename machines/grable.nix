{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../configs/base.nix
      ../configs/users-and-groups.nix
      ../configs/intel-vaapi.nix
      ./hardware-grable.nix
      #../configs/wireguard.nix
      <nixos-hardware/dell/xps/13-9370>
    ];


  # Use the GRUB 2 boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = false;
  boot.loader.grub.efiSupport = true;

  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.extraEntries = builtins.readFile ../configs/extra.grub;

  #boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  #environment.systemPackages = [ pkgs.wireguard ];

  networking.hostName = "grable";
  networking.hostId = "1a9f9478";

  powerManagement.powertop.enable = true;

  nix = {
    buildCores = 8;
    maxJobs = 4;
  };

  systemd.timers.cpu-throttling.enable = lib.mkForce false;

  services = {
    throttled = {
      enable = true;
      #extraConfig = builtins.readFile ../configs/lenovo_fix.conf;
    };

    thermald.enable = lib.mkForce false;
    # Start syncthing via QSyncthingTray
    syncthing.enable = lib.mkForce false;
    tlp.enable = lib.mkForce false;

    xserver = {
      videoDrivers = [ "intel" ];
      deviceSection = ''
        Option "AccelMethod" "UXA"
      '';
      #Option "TearFree" "true"
      useGlamor = false;
      layout = "en_US";
    };
  };
}
