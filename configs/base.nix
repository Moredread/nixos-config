{ config, lib, pkgs, ... }:

{
  imports = [
    ./base-testing.nix
  ];

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;

  nix = {
    buildCores = 4;
    maxJobs = 4;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.de
    aspellDicts.en
    blender
    coreutils
    dmenu
    findutils
    firefox
    freecad
    gitAndTools.gitFull
    google-chrome
    gource
    gparted
    i3lock
    i3status
    iftop
    ioping
    iotop
    iputils
    jq
    libreoffice
    llvmPackages.clang
    neovim
    netcat
    nettools
    nfs-utils
    nix-zsh-completions
    oh-my-zsh
    pwgen
    python27Full
    python27Packages.virtualenvwrapper
    python35Full
    python35Packages.virtualenvwrapper
    ripgrep
    rsync
    rxvt_unicode
    screen
    skype
    sloccount
    socat
    spice
    spotify
    subversion
    telnet
    vimHugeX
    wineUnstable
    wirelesstools
    wpa_supplicant
    wpa_supplicant_gui
    xsel
    youtube-dl
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-navigation-tools
    zsh-syntax-highlighting
  ];

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      google-fonts
      inconsolata  # monospaced
      mononoki
      source-code-pro
      source-sans-pro
      source-serif-pro
      ttf_bitstream_vera
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
#     corefonts  # Microsoft free fonts
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };
      ultimate = {
        enable = false;
      };
    };
  };

  services = {
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
#      displayManager.gdm.enable = true;
#      displayManager.gdm.autoLogin.enable = true;
#      displayManager.gdm.autoLogin.user = "vagrant";
    };

    openssh.enable = true;
    dbus.enable    = true;

    # Replace nptd by timesyncd
    timesyncd.enable = true;
  };

  programs = {
    zsh.enable = true;
  };


}
