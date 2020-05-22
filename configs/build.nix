{ config, lib, pkgs, ... }:

{
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "192.168.0.118";
        maxJobs = 4;
        sshKey = "/root/.ssh/id_ed25519";
        sshUser = "addy";
        system = "x86_64-linux";
        supportedFeatures = [ ];
      }
      {
        hostName = "192.168.0.149";
        maxJobs = 4;
        sshKey = "/root/.ssh/id_ed25519";
        sshUser = "addy";
        system = "x86_64-linux";
        supportedFeatures = [ ];
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

}
