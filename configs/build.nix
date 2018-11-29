{ config, lib, pkgs, ... }:

{
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "aarch64.nixos.community";
        maxJobs = 64;
        sshKey = "/root/.ssh/id_ed25519";
        sshUser = "moredread";
        system = "aarch64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
  };

}
