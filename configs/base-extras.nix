{ config, lib, pkgs, ... }:

{
  # seldomly used packages
  environment.systemPackages = with pkgs; [
    apg
    arp-scan
    ascii
    bc
    ctags
    ddrescue
    diffstat
    exiv2
    freecad
    jq
    minicom
    picocom
    spice
  ];
}
