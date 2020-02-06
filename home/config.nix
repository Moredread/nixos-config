{
  allowUnfree = true;
  allowBroken = true;

  packageOverrides = pkgs: {
    ccacheWrapper = pkgs.ccacheWrapper.override {
      extraConfig = ''
        export CCACHE_COMPRESS=1
        export CCACHE_DIR=/var/cache/ccache
        export CCACHE_UMASK=007
      '';
    };
    nur = import <nur> {
      inherit pkgs;
    };
  };

  kodi = {
    enableControllers = true;
    enableAdvancedLauncher = true;
  };

  oraclejdk.accept_license = true;
}
