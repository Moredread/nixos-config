{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
  }) { inherit pkgs; };
  packageOverridesOverlay = self: super: {
    nur = nur;
    unstable = unstable;

    appimage-run = super.appimage-run.override { extraPkgs = pkgs: [ pkgs.jack2 ]; };
    renoise = unstable.renoise.override { releasePath = ~/Downloads/rns_3_1_1_linux_x86_64.tar.gz; };

    i3status-rust = nur.repos.moredread.i3status-rust;

    gitwatch = pkgs.callPackage ../pkgs/gitwatch.nix { };

    pass-custom = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);
    lsd = unstable.lsd;
    nixopsUnstable = unstable.nixopsUnstable;
    #syncthing = unstable.syncthing;
    #qsyncthingtray = unstable.qsyncthingtray;
  };
in
{
  nixpkgs.overlays = [ packageOverridesOverlay ];
}
