{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../configs/base.nix
      ../configs/users-and-groups.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_1TB_S2RFNX0J114023V";

  boot.blacklistedKernelModules = [ "i915" ];

  networking.networkmanager.enable = true;
  networking.hostName = "minuteman";

  networking.firewall.allowedTCPPorts = [
    22000  # syncthing
  ];

  networking.firewall.allowedUDPPorts = [
    21027  # syncthing
  ];

  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  services = {
    thermald.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
#    xserver.videoDrivers = [ "nouveau" ];
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = true;

  

#  security.grsecurity.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5c8e9a10-0cd9-4032-b6f8-3d824b08bab2";
      fsType = "btrfs";
      options = [ "ssd_spread,noatime,discard,ssd,autodefrag,compress=lzo,space_cache" ];
    };

  boot.initrd.luks.devices."root-crypt".device = "/dev/disk/by-uuid/4cdce7e2-5fee-472c-b58f-be8fdb8ccbac";
  boot.initrd.luks.devices."root-crypt".allowDiscards = true;

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7dd8692c-96aa-4ab0-aaae-de8acbf745ff";
      fsType = "ext4";
    };

  hardware = {
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true; # This might be needed for Steam games
    opengl.driSupport32Bit = true;
    opengl.driSupport = true;
    opengl.enable = true;
    sane.enable = true; # scanner support
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec { 
         gajim = pkgs.gajim.override { enableNotifications = true; };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';
}
