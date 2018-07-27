{ config, lib, pkgs, ... }:

{
  # adapted from https://gist.github.com/joedicastro/a19a9dfd21470783240c739657747f5d
  systemd.user.services."autocutsel-clipboard" = {
    enable = true;
    description = "AutoCutSel for CLIPBOARD buffer";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 10;
    serviceConfig.StartLimitIntervalSec = 60;
    serviceConfig.StartLimitBurst = 3;
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD -fork";
  };

  systemd.user.services."autocutsel-primary" = {
    enable = true;
    description = "AutoCutSel for PRIMARY buffer";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 10;
    serviceConfig.StartLimitIntervalSec = 60;
    serviceConfig.StartLimitBurst = 3;
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork";
  };
}
