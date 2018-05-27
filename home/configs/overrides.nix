{ pkgs, lib, ... }:
let
  overlay = self: super: {
    slic3r-prusa3d = super.callPackage ../pkgs/slic3r-prusa3d.nix {};
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
