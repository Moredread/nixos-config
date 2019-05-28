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

    pass-custom = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);
    lsd = unstable.lsd;

    nix-lsp = pkgs.callPackage ../pkgs/nix-lsp { rustPlatform = nur.repos.mic92.rustNightlyPlatform; };
  } // lib.filterAttrs (n: v: v != null) {
    # TODO: can this be expressed better?
    renoise = if builtins.pathExists renoisePath
    then unstable.renoise.override { releasePath = renoisePath; }
    else null;
  };
in
{
  nixpkgs.overlays = [ packageOverridesOverlay ];
}
