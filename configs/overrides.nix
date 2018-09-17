{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
  master = import /home/addy/nixpkgs { config = baseconfig; };
  overlay = self: super: {
    unifi = unstable.unifi;
    emby = unstable.emby;
    microcodeIntel = unstable.microcodeIntel;
  };
in rec {
  nixpkgs.overlays = [ overlay ];
}
