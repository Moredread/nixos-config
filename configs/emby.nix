{ config, lib, pkgs, ... }:

{
  services.emby.enable = true;
  # Disable autostart
  systemd.services.emby.wantedBy = lib.mkForce [];

  users.extraUsers.emby.extraGroups = [ "sabnzbd" ];

  networking.firewall.allowedTCPPorts = [ 8096 8920 ];
}
