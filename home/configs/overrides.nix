{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  overlay = self: super: {
    gitwatch = pkgs.callPackage ../pkgs/gitwatch.nix { };
    slic3r-prusa3d = pkgs.callPackage ../pkgs/slic3r-prusa3d.nix { };
    electrum = unstable.electrum;
    freecad = unstable.freecad;
    syncthing = unstable.syncthing;
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
