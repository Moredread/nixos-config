{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
  master = import /home/addy/nixpkgs { config = baseconfig; };
  overlay = self: super: {
    unifi = unstable.unifi;
    emby = unstable.emby;
    microcodeIntel = unstable.microcodeIntel;
    syncthing = unstable.syncthing;
  };
in rec {
  nixpkgs.overlays = [ overlay ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      #url = "https://github.com/nix-community/NUR/archive/759731081383d8aee4bb9255b8e22852f4abf5a7.tar.gz";
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      #sha256 = "1v2nnm8jp0lq484fl3d9hic3m78yc2h4h8nrfhidgq2mj38pn5fj";
    }) {
      inherit pkgs;
    };
  };
}
