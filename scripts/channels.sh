#!/usr/bin/env bash

ADD="nix-channel --add"
VERSION="19.03"

# TODO: Less redundancy
$ADD https://github.com/rycee/home-manager/archive/release-$VERSION.tar.gz home-manager
$ADD https://nixos.org/channels/nixos-$VERSION nixos
$ADD https://nixos.org/channels/nixos-$VERSION nixpkgs
$ADD https://nixos.org/channels/nixos-unstable nixos-unstable

nix-channel --update
nix-channel --list

sudo $ADD https://github.com/rycee/home-manager/archive/release-$VERSION.tar.gz home-manager
sudo $ADD https://nixos.org/channels/nixos-$VERSION nixos
sudo $ADD https://nixos.org/channels/nixos-$VERSION nixpkgs
sudo $ADD https://nixos.org/channels/nixos-unstable nixos-unstable

sudo nix-channel --update
sudo nix-channel --list
