{ config, lib, pkgs, ... }:

{
  services.sabnzbd.enable = true;

  # Disable autostart
  systemd.services.sabnzbd.wantedBy = lib.mkForce [];
}
