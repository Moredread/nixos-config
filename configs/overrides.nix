{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
in {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unifi = unstable.unifi;
      emby = unstable.emby;
      #sane-backends = unstable.sane-backends;
      #sane-backends-git = unstable.sane-backends-git;
    };
  };
}
