{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    services.pasystray = {
      enable = mkEnableOption "pasystray";
    };
  };

  config = mkIf config.services.pasystray.enable {
    systemd.user.services.pasystray = {
        Unit = {
          Description = "pasystray";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.pasystray}/bin/pasystray";
        };
    };
  };
}
