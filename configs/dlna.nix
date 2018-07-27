{ config, lib, pkgs, ... }:

{
  services.minidlna = {
      config = ''
        media_dir=/var/lib/media
        friendly_name=Laptop
        db_dir=/var/lib/media/dlna
        log_dir=/var/lib/media/log
        inotify=yes'';
       enable = true;
    };

  networking.firewall.allowedUDPPorts = [ 8200 ];
  networking.firewall.allowedTCPPorts = [ 8200 ];

  # Disable autostart
  systemd.services.minidlna.wantedBy = lib.mkForce [];
}
