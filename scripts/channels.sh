#!/usr/bin/env bash

ADD="nix-channel --add"
NIXOS_VERSION="19.09"

# TODO: Less redundancy
$ADD https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
$ADD https://nixos.org/channels/nixos-$NIXOS_VERSION nixos
$ADD https://nixos.org/channels/nixos-$NIXOS_VERSION nixpkgs
$ADD https://nixos.org/channels/nixos-unstable nixos-unstable

nix-channel --update
nix-channel --list

sudo $ADD https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
sudo $ADD https://nixos.org/channels/nixos-$NIXOS_VERSION nixos
sudo $ADD https://nixos.org/channels/nixos-$NIXOS_VERSION nixpkgs
sudo $ADD https://nixos.org/channels/nixos-unstable nixos-unstable

sudo nix-channel --update
sudo nix-channel --list
