#!/usr/bin/env bash

ADD="nix-channel --add"
NIXOS_VERSION="19.09"

# TODO: Less redundancy
$ADD https://github.com/rycee/home-manager/archive/release-$NIXOS_VERSION.tar.gz home-manager
$ADD https://github.com/nix-community/NUR/archive/master.tar.gz nur
$ADD https://nixos.org/channels/nixos-$NIXOS_VERSION nixos
$ADD https://nixos.org/channels/nixos-$NIXOS_VERSION nixpkgs
$ADD https://nixos.org/channels/nixos-unstable nixos-unstable
$ADD https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz mozilla-overlay

nix-channel --update
nix-channel --list
