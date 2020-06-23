{ pkgs, lib, ... }:
let
  # removes attrs in `nameList` from `set`
  filterAttrs = nameList: set: builtins.listToAttrs (map (x: lib.nameValuePair x set.${x}) nameList);

  unstable_ = import <nixos-unstable> {};

  renoisePath = ~/Downloads/rns_3_1_1_linux_x86_64.tar.gz;
  mozilla_overlay = import <mozilla-overlay>;
  packageOverridesOverlay = self: super: rec {
    nur = import <nur> { inherit pkgs; };
    nur-unstable = import <nur> { pkgs = unstable_; };
    unstable = unstable_;

    appimage-run = super.appimage-run.override { extraPkgs = pkgs: [ pkgs.jack2 ]; };

    pass-custom = pkgs.pass.withExtensions (ext: [ ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import ]);

    rnix-lsp = pkgs.callPackage ../pkgs/rnix-lsp {};

    nightly = super.rustChannelOf {
      date = "2020-04-26";
      channel = "nightly";
    };

    rustNightlyPlatform = super.makeRustPlatform {
      cargo = nightly.rust;
      rustc = nightly.rust;
    };

    nix-universal-prefetch = pkgs.callPackage (
      pkgs.fetchFromGitHub {
        owner = "samueldr";
        repo = "nix-universal-prefetch";
        rev = "829e7d56510af144ed4c000d378355a0ebae6072";
        sha256 = "09465fpc74g3waxx88yqjk5sj5vs523c0kvil6fkivbwyyjpzmvf";
      }
    ) {};

    nixos-generators = pkgs.callPackage (
      pkgs.fetchFromGitHub {
        owner = "nix-community";
        repo = "nixos-generators";
        rev = "9edb9f7bdf4c9b0c4c19993c1f5deed74d1f478d";
        sha256 = "16k3as3q59g0n1yadb6d18lxw7hfdrs9llvl33lbjwgy82pg25a4";
      }
    ) {};

  } // lib.optionalAttrs (builtins.pathExists renoisePath) {
    #Infinite recursion problems
    #renoise = pkgs.renoise.override { releasePath = renoisePath; };
  } // filterAttrs [
    # use unstable version of following packages
    "broot"
    "joplin-desktop"
    "syncthing"
  ] unstable_;
in

{
  nixpkgs.overlays = [ mozilla_overlay packageOverridesOverlay ];
}
