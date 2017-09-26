# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c33a7ce5-cf2e-4774-9caa-0fa0421804a7";
      fsType = "btrfs";
      options = [ "compress,autodefrag,ssd,discard" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/457c3e3b-e3c9-483c-a266-348421cb2a4b";
  boot.initrd.luks.devices."root".allowDiscards = true;

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/f57d3072-85db-4e38-9c81-b92bc3c2b9a6";
      fsType = "ext4";
      options = [ "discard" ];
    };

  swapDevices = [ ];

}
