{ pkgs, lib, ... }:
let
  unstable_ = import <nixos-unstable> {};
  nur_ = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
  }) { inherit pkgs; };
  renoisePath = ~/Downloads/rns_3_1_1_linux_x86_64.tar.gz;
  filterAttrs = nameList: set: builtins.listToAttrs (map (x: lib.nameValuePair x set.${x}) nameList);
  mozilla_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  packageOverridesOverlay = self: super: rec {
    nur = nur_;
    unstable = unstable_;

    appimage-run = super.appimage-run.override { extraPkgs = pkgs: [ pkgs.jack2 ]; };
    #i3status-rust = nur.repos.moredread.i3status-rust;

    pass-custom = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);

    rnix-lsp = pkgs.callPackage ../pkgs/rnix-lsp { };

    nightly = super.rustChannelOf {
      date = "2019-10-03";
      channel = "nightly";
    };

    rustNightlyPlatform = super.makeRustPlatform {
      cargo = nightly.rust;
      rustc = nightly.rust;
    };

    nix-universal-prefetch = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "samueldr";
      repo = "nix-universal-prefetch";
      rev = "829e7d56510af144ed4c000d378355a0ebae6072";
      sha256 = "09465fpc74g3waxx88yqjk5sj5vs523c0kvil6fkivbwyyjpzmvf";
    }) {};

    nixos-generators = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "nix-community";
      repo = "nixos-generators";
      rev = "9edb9f7bdf4c9b0c4c19993c1f5deed74d1f478d";
      sha256 = "16k3as3q59g0n1yadb6d18lxw7hfdrs9llvl33lbjwgy82pg25a4";
    }) {};

  } // lib.optionalAttrs ( builtins.pathExists renoisePath ) {
    #Infinite recursion problems
    #renoise = pkgs.renoise.override { releasePath = renoisePath; };
  } // filterAttrs [
    # use unstable version of following packages
    "alacritty"
    "blender"
    "browserpass"
    "darktable"
    "freecad"
    "libreoffice"
    "lsd"
    "syncthing"
    "travis"
  ] unstable_;
in

{
  nixpkgs.overlays = [ mozilla_overlay packageOverridesOverlay ];
}
