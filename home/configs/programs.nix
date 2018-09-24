{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

    browserpass.enable = true;
    htop.enable = true;
    lesspipe.enable = true;
    man.enable = true;
    neovim.enable = true;
    zathura.enable = true;
    noti.enable = true;
  };
}
