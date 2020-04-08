{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
              ./configs/packages.nix
              ./configs/overrides.nix
            ];

  home.packages = with pkgs; [
    rsync
    aria2
    fd
    git
    gnupg
    htop
    jq
    less
    mosh
    neovim
    openssh
    qrencode
    ripgrep
    strace
    travis
    vim
    entr
    zstd
    xz
    zsh
    screen
    tmux

  ];
}
