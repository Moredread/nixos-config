{ config, lib, pkgs, ... }:

{
  # Packages I'm unsure I want to keep
  environment.systemPackages = with pkgs; [
    #teamviewer  # changes hash all the time
    anki
    criu
    nix-generate-from-cpan
    nix-prefetch-scripts
    nix-repl
    nixops
    nixpkgs-lint
    nox
    solfege
    sshfsFuse
    stdmanpages
#    sysdig
    tig
    unoconv
    virtmanager
    virtviewer
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
#    sysdig
  ];
}
