{ pkgs, ... }:
{
  imports = [
    configs/packages.nix
    configs/programs.nix
    configs/wm.nix
  ];

  home.keyboard.layout = "en_US";
  home.language = {
    base = "en_US.utf8";
    paper = "de_DE.utf8";
    monetary = "de_DE.utf8";
    address = "de_DE.utf8";
  };

  systemd.user.startServices = true;
}
