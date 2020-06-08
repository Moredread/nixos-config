{ pkgs, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    bzip2
    diffutils
    findutils
    git
    gnugrep
    gnupg
    gnused
    gnutar
    gzip
    hostname
    man
    neovim
    openssh
    tzdata
    unzip
    utillinux
    vim
    xz
    youtube-dl
    zip
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
