{ config, lib, pkgs, ... }:

{
  imports = [
    ./base-testing.nix
  ];

#  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    ansible
    aspellDicts.de
    aspellDicts.en
    blender
    cmake
    coreutils
    dmenu
    findutils
    firefox
    freecad
    freetype
    gajim
    gcc
    gitAndTools.gitFull
    glxinfo
    gnumake
    gnupg
    google-chrome
    gource
    gparted
    i3lock
    i3status
    i7z
    idea.pycharm-professional
    iftop
    ioping
    iotop
    iptables
    iputils
    jq
    keepassx2
    libreoffice
    llvmPackages.clang
    mosh
    mpv
    mumble
    neovim
    netcat
    nettools
    networkmanagerapplet 
    nfs-utils
    nix-zsh-completions
    nmap
    ntfs3g
    oh-my-zsh
    pavucontrol
    pkgconfig
    polkit_gnome
    pwgen
    python27Full
    python27Packages.virtualenvwrapper
    python35Full
    python35Packages.virtualenvwrapper
    qsyncthingtray
    ranger
    ripgrep
    rsync
    rustNightly.cargo
    rustNightly.rustc
    rustfmt
    rxvt_unicode
    screen
    skype
    sloccount
    socat
    spice
    spotify
    steam
    subversion
    syncthing
    syncthing-inotify
    telnet
    udiskie
    vagrant
    vimHugeX
    vlc
    wget
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
    zstd
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
