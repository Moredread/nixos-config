{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
  }) { inherit pkgs; };
  renoisePath = ~/Downloads/rns_3_1_1_linux_x86_64.tar.gz;
  packageOverridesOverlay = self: super: {
    nur = nur;
    unstable = unstable;

    appimage-run = super.appimage-run.override { extraPkgs = pkgs: [ pkgs.jack2 ]; };

    i3status-rust = nur.repos.moredread.i3status-rust;
    browserpass = unstable.browserpass;
    travis = unstable.travis;

    pass-custom = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);
    lsd = unstable.lsd;
    syncthing = unstable.syncthing;
    darktable = unstable.darktable;

    nix-lsp = pkgs.callPackage ../pkgs/nix-lsp { rustPlatform = nur.repos.mic92.rustNightlyPlatform; };

    nix-universal-prefetch = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "samueldr";
      repo = "nix-universal-prefetch";
      rev = "829e7d56510af144ed4c000d378355a0ebae6072";
      sha256 = "09465fpc74g3waxx88yqjk5sj5vs523c0kvil6fkivbwyyjpzmvf";
    }) {};
  } // lib.optionalAttrs ( builtins.pathExists renoisePath ) {
    #Infinite recursion problems
    #renoise = pkgs.renoise.override { releasePath = renoisePath; };
  };
in
{
  nixpkgs.overlays = [ packageOverridesOverlay ];
}
