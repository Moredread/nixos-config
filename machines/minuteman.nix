{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../configs/base.nix
      #../configs/wireguard.nix
      ../configs/users-and-groups.nix
    ];

  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;

    loader.grub.memtest86.enable = true;
    loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_1TB_S2RFNX0J114023V";

    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.luks.devices."root-crypt".device = "/dev/disk/by-uuid/4cdce7e2-5fee-472c-b58f-be8fdb8ccbac";
    #initrd.luks.devices."root-crypt".allowDiscards = true;

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
  };


  networking.hostName = "minuteman";
  networking.hostId = "0eee33a8";

  time.hardwareClockInLocalTime = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/5c8e9a10-0cd9-4032-b6f8-3d824b08bab2";
      fsType = "btrfs";
      options = [ "relatime,ssd,autodefrag,compress=zstd,space_cache" ];
    };

  fileSystems."/media/nas" =
    {
      device = "192.168.43.1:/mnt/pool0/public";
      fsType = "nfs";
      options = [ "soft" "bg" ];
    };

  fileSystems."/media/nasw" =
    {
      device = "192.168.1.1:/mnt/pool0/data/public";
      fsType = "nfs";
      options = [ "soft" "bg" ];
    };

  powerManagement.cpuFreqGovernor = "ondemand";

  services.xserver.videoDrivers = [ "nvidia" ];

  #programs.adb.enable = true;

  i18n.consoleKeyMap = "us";
  services.xserver.layout = "us";

  nix.buildCores = lib.mkForce 16;

  nix.buildMachines = [
#    {
#      hostName = "grable";
#      maxJobs = 8;
#      sshKey = "/root/.ssh/id_ed25519";
#      sshUser = "addy";
#      system = "x86_64-linux";
#      supportedFeatures = [ "big-parallel" "kvm" "nixos-test" ];
#    }
  ];


  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/fee6564b-baea-4bcb-b531-78679b083d3c";
      fsType = "ext4";
      options = [ "relatime" ];
    };
}
