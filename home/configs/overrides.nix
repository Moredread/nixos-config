{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
  }) { inherit pkgs; };
  packageOverridesOverlay = self: super: {
    nur = nur;
    unstable = unstable;

    i3status-rust = nur.repos.moredread.i3status-rust;

    gitwatch = pkgs.callPackage ../pkgs/gitwatch.nix { };
    slic3r-prusa3d = pkgs.callPackage ../pkgs/slic3r-prusa3d.nix { };

    alacritty = unstable.alacritty;
    i3 = unstable.i3;
    neovim = unstable.neovim;
    nix-du = unstable.nix-du;
    nixopsUnstable = unstable.nixopsUnstable;
    noti = unstable.noti;
    syncthing = unstable.syncthing;
    you-get = unstable.you-get;
  };
in
{
  nixpkgs.overlays = [ packageOverridesOverlay ];
}
