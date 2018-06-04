{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  overlay = self: super: {
    gitwatch = pkgs.callPackage ../pkgs/gitwatch.nix { };
    slic3r-prusa3d = pkgs.callPackage ../pkgs/slic3r-prusa3d.nix { };
    freecad = unstable.freecad;
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
