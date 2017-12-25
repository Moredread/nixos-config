{ config, lib, pkgs, ... }:

{
  services.unifi = {
    enable = true;
    openPorts = true;
  };

  # Disable autostart
  systemd.services.unifi.wantedBy = lib.mkForce [];
}
