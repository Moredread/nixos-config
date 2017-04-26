{ config, lib, pkgs, ... }:

{
  # Packages I'm unsure I want to keep
  environment.systemPackages = with pkgs; [
    anki
    #teamviewer  # changes hash all the time
    solfege
    unoconv
    virtmanager
    virtviewer
  ];
}
