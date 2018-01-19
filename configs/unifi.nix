{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
in {
  services.unifi = {
    enable = true;
    openPorts = true;
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unifi = unstable.unifi;
    };
  };

  # Disable autostart
  systemd.services.unifi.wantedBy = lib.mkForce [];
}
