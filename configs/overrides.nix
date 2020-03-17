{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  _unstable = import <nixos-unstable> { config = baseconfig; };
  _master = import /home/addy/nixpkgs { config = baseconfig; };
  _nur = import <nur> { inherit pkgs; };
  overlay = self: super: rec {
    unifi = unstable.unifi;
    emby = unstable.emby;
    microcodeIntel = unstable.microcodeIntel;
    syncthing = unstable.syncthing;
    unstable = _unstable;
    master = _master;
    throttled = unstable.throttled;
  };
in
rec {
  nixpkgs.overlays = [ overlay ];

}
