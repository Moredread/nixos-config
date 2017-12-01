{ pkgs, ... }:
{
  imports = [
    configs/packages.nix
    configs/programs.nix
    configs/wm.nix
  ];

  home.keyboard.layout = "de";
  home.language = {
    paper = "de";
    monetary = "de";
    address = "de";
  };


}
