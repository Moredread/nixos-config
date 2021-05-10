{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  _unstable = import <nixos-unstable> { config = baseconfig; };
  _master = import /home/addy/nixpkgs { config = baseconfig; };
  _nur = import <nur> { inherit pkgs; };
  overlay = self: super: {
    unifi = _unstable.unifi;
    emby = _unstable.emby;
    microcodeIntel = _unstable.microcodeIntel;
    syncthing = _unstable.syncthing;
    unstable = _unstable;
    tailscale = _unstable.tailscale;
    #master = _master;
    #throttled = _unstable.throttled;
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
