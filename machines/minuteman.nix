{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../configs/base.nix
      ../configs/users-and-groups.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_1TB_S2RFNX0J114023V";

  boot.cleanTmpDir = true;

  networking.hostName = "minuteman";
  networking.hostId = "0eee33a8";

  time.hardwareClockInLocalTime = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5c8e9a10-0cd9-4032-b6f8-3d824b08bab2";
      fsType = "btrfs";
      options = [ "relatime,ssd,autodefrag,compress=zlib,space_cache" ];
    };

  boot.initrd.luks.devices."root-crypt".device = "/dev/disk/by-uuid/4cdce7e2-5fee-472c-b58f-be8fdb8ccbac";
  #boot.initrd.luks.devices."root-crypt".allowDiscards = true;

  powerManagement.cpuFreqGovernor = "ondemand";

  services.xserver.videoDrivers = [ "nvidia" ];

  programs.adb.enable = true;

  i18n.consoleKeyMap = "us";
  services.xserver.layout = "us";

  nix.buildCores = lib.mkForce 8;

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/fee6564b-baea-4bcb-b531-78679b083d3c";
      fsType = "ext4";
        options = [ "relatime" ];
    };
}
