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
    neovim = unstable.neovim;
    nix-du = unstable.nix-du;
    i3 = super.i3.overrideAttrs (attrs: rec {
      name = "i3-${version}";
      version = "4.16";
      src = self.fetchurl {
        url = "https://i3wm.org/downloads/${name}.tar.bz2";
        sha256 = "1d2mnryn7m9c6d69awd7lwzadliapd0ahi5n8d0ppqy533ssaq6c";
      };
    });
    #renoise = super.renoise.override { releasePath = /nix/store/gy1r3hkvm48qz1pvhcmvfcnscn3n49av-rns_3_1_1_linux_x86_64.tar.gz; };
  };
in
{
  nixpkgs.config = {
    retroarch = {
      enableDolphin = true;
      enableMGBA = true;
      #enableMAME = true;
      enableScummVM = true;
      enableSnes9x = true;
      enableSnes9xNext = true;
    };
    allowUnfree = true;
  };
  nixpkgs.overlays = [ overlay ];
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      #sha256 = "1v2nnm8jp0lq484fl3d9hic3m78yc2h4h8nrfhidgq2mj38pn5fj";
    }) {
      inherit pkgs;
    };
  };
}
