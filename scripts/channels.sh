#!/usr/bin/env bash

ADD="nix-channel --add"

# TODO: Less redundancy
$ADD https://github.com/rycee/home-manager/archive/release-19.03.tar.gz home-manager
$ADD https://nixos.org/channels/nixos-19.03 nixos
$ADD https://nixos.org/channels/nixos-unstable nixos-unstable
$ADD https://nixos.org/channels/nixos-19.03 nixpkgs

nix-channel --update
nix-channel --list

sudo $ADD https://github.com/rycee/home-manager/archive/release-19.03.tar.gz home-manager
sudo $ADD https://nixos.org/channels/nixos-19.03 nixos
sudo $ADD https://nixos.org/channels/nixos-unstable nixos-unstable
sudo $ADD https://nixos.org/channels/nixos-19.03 nixpkgs

sudo nix-channel --update
sudo nix-channel --list
