{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    home-manager.path = https://github.com/rycee/home-manager/archive/release-18.09.tar.gz;

    browserpass.enable = true;
    htop.enable = true;
    lesspipe.enable = true;
    man.enable = true;
    neovim.enable = true;
  };
}
