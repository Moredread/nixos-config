{
  allowUnfree = true;
  allowBroken = true;

  overlays = [ (self: pkgs: {
    ccacheWrapper = pkgs.ccacheWrapper.override {
      extraConfig = ''
        export CCACHE_COMPRESS=1
        export CCACHE_UMASK=007
        CCACHE_BASEDIR=/tmp
        CCACHE_DIR=/build/.ccache
     '';
    };
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  })];

  kodi = {
    enableControllers = true;
    enableAdvancedLauncher = true;
  };

  oraclejdk.accept_license = true;

  # Haven't figured out how to use it yet
  #replaceStdenv = { pkgs }: pkgs.ccacheStdenv;
}
