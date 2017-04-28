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
    chromium
    gource
    gparted
    i3lock
    i3status
    i7z
#    idea.pycharm-professional
    iftop
    unrar
    unzip
    p7zip
    ioping
    iotop
    iptables
    iputils
    jq
    keepassx2
    libreoffice
    llvmPackages.clang
    mpv
    ffmpeg
    smartmontools
    mumble
    neovim
    netcat
    nettools
    electrum
    networkmanagerapplet 
#    nfs-utils
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
#    steam
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
    wireshark
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

    udev.extraRules = ''
    # Trezor
    SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"
    '';
  };

  programs = {
    fish.enable = true;
    java.enable = true;
    mosh.enable = true;
    wireshark.enable = true;
    zsh.enable = true;

    chromium = {
        enable = true;
        # Imperatively installed extensions will seamlessly merge with these.
        # Removing extensions here will remove them from chromium, no matter how
        # they were installed.
        extensions = [
          "cmedhionkhpnakcndndgjdbohmhepckk" # Adblock for Youtube™
#          "bodncoafpihbhpfljcaofnebjkaiaiga" # appear.in screen sharing
          "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
          "jcjjhjgimijdkoamemaghajlhegmoclj" # Trezor
#          "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        ];
    };
  };


}
