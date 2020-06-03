{ pkgs, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim  # or some other editor, e.g. nano or neovim
    neovim
    # Some common stuff that people expect to have
    diffutils
    git
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    youtube-dl
    unzip
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "19.09";

  # After installing home-manager channel like
  #   nix-channel --add https://github.com/rycee/home-manager/archive/release-19.09.tar.gz home-manager
  #   nix-channel --update
  # you can configure home-manager in here like
  #home-manager.config =
  #  { pkgs, ... }:
  #  {
  #    # insert home-manager config
  #  };
}

# vim: ft=nix
