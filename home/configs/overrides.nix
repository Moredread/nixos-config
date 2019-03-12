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

    alacritty = unstable.alacritty;
    direnv = unstable.direnv;
    pass-custom = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);
    i3 = unstable.i3;
    neovim = unstable.neovim;
    nix-du = unstable.nix-du;
    nixopsUnstable = unstable.nixopsUnstable;
    noti = unstable.noti;
    #syncthing = unstable.syncthing;
    #qsyncthingtray = unstable.qsyncthingtray;
    you-get = unstable.you-get;
  };
in
{
  nixpkgs.overlays = [ packageOverridesOverlay ];
}
