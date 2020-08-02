{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    home-manager.path = <home-manager>;

    neovim.enable = true;
    browserpass.browsers = [ "chrome" "chromium" "firefox" ];
    broot.enable = true;
    browserpass.enable = true;
    command-not-found.enable = false;
    direnv.enable = true;
    feh.enable = true;
    htop.enable = true;
    jq.enable = true;
    lesspipe.enable = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    man.enable = true;
    noti.enable = true;
    zathura.enable = true;

    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;
      signing.key = "24B45728";
      signing.signByDefault = true;
      userEmail = "code@apb.name";
      userName = "André-Patrick Bubel";
      aliases = {
        a = "add";
        ca = "commit -a";
        c = "commit";
        co = "checkout";
        d = "diff";
        l = "log";
        rh = "reset --hard";
        s = "status";
        t = "tag";
        glog = "log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph";
      };
    };

    #    password-store = {
    #      enable = true;
    #      package = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);
    #      settings = {
    #        PASSWORD_STORE_DIR = "$HOME/.password-store";
    #        PASSWORD_STORE_GPG_OPTS = "-a";
    #      };
    #    };

    keychain = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      keys = [ "id_ed25519" "id_rsa" ];
    };
  };
}
