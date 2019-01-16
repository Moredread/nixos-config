{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

    browserpass.enable = true;
    browserpass.browsers = [ "chrome" "chromium" "firefox" ];
    htop.enable = true;
    jq.enable = true;
    lesspipe.enable = true;
    man.enable = true;
    neovim.enable = true;
    noti.enable = true;
    zathura.enable = true;
  };
}
