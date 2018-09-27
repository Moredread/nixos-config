{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  overlay = self: super: {
    gitwatch = pkgs.callPackage ../pkgs/gitwatch.nix { };
    alacritty = unstable.alacritty;
    slic3r-prusa3d = pkgs.callPackage ../pkgs/slic3r-prusa3d.nix { };
    #electrum = unstable.electrum;
    #freecad = unstable.freecad;
    syncthing = unstable.syncthing;
    nixopsUnstable = unstable.nixopsUnstable;
    cachix = unstable.cachix;
    noti = unstable.noti;
    #renoise = super.renoise.override { releasePath = /nix/store/gy1r3hkvm48qz1pvhcmvfcnscn3n49av-rns_3_1_1_linux_x86_64.tar.gz; };
  };
in
{
  nixpkgs.config = {
    retroarch = {
      #enableDolphin = true;
      #enableMGBA = true;
      #enableMAME = true;
      #enableScummVM = true;
      #enableSnes9x = true;
      #enableSnes9xNext = true;
    };
    allowUnfree = true;
  };
  nixpkgs.overlays = [ overlay ];
}
