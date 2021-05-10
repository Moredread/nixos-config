{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  _unstable = import <nixos-unstable> { config = baseconfig; };
  _master = import /home/addy/nixpkgs { config = baseconfig; };
  _nur = import <nur> { inherit pkgs; };
  overlay = self: super: {
    emby = _unstable.emby;
    microcodeIntel = _unstable.microcodeIntel;
    syncthing = _unstable.syncthing;
    unifi = _unstable.unifi;
    unstable = _unstable;
    #master = _master;
    #throttled = _unstable.throttled;
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
