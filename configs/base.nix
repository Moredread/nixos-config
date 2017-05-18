{ config, lib, pkgs, ... }:

{
  imports = [
    ./base-testing.nix
    ./base-extras.nix
  ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = lib.mkDefault "us";
    defaultLocale = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
      EDITOR = pkgs.lib.mkOverride 0 "vim";
  };

  environment.systemPackages = with pkgs; [
    ansible
    aspellDicts.de
    aspellDicts.en
    blender
    bridge-utils
    chromium
    cifs_utils  # for mount.cifs, needed for cifs filesystems in systemd.mounts.
    cmake
    colordiff
    coreutils
    dmenu
    dmidecode
    dos2unix
    electrum
    ffmpeg
    findutils
    firefox-bin
    freetype
    gajim
    gcc
    gitFull
    gnucash
    gnumake
    gnupg
    gnupg1
    gource
    gparted
    hdparm
    htop
    i3lock
    i3status
    i7z
    iftop
    ioping
    iotop
    iptables
    iputils
    kdiff3
    keepassx2
    libreoffice
    llvmPackages.clang
    lm_sensors
    lsof
    mdadm
    mpv
    mumble
    ncdu
    neovim
    netcat
    nettools
    networkmanagerapplet 
    nix-zsh-completions
    nmap
    ntfs3g
    oh-my-zsh
    openvpn
    p7zip
    parted
    pavucontrol
    pkgconfig
    polkit_gnome
    posix_man_pages
    psmisc
    pv
    pwgen
    python27Full
    python27Packages.virtualenvwrapper
    python2nix
    python35Full
    python35Packages.ipython
    python35Packages.virtualenvwrapper
    qsyncthingtray
    ranger
    ripgrep
    rsync
    rxvt_unicode
    scons
    screen
    skype
    sloccount
    smartmontools
    socat
    spotify
    steam
    subversion
    syncthing
    syncthing-inotify
    telnet
    thunderbird
    udiskie
    unrar
    unzip
    urxvt_font_size
    urxvt_perls
    vagrant
    vimHugeX
    vlc
    weechat
    wget
    powertop
    glxinfo
    wpa_supplicant
    wpa_supplicant_gui
    xsel
    youtube-dl
    zdfmediathk
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-navigation-tools
    zsh-syntax-highlighting
    zstd
#    idea.pycharm-professional
#    nfs-utils
  ];

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      fira
      fira-mono
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
        enable = true;
      };
    };
  };

  services = {
    xserver = {
      enable = true;

      windowManager.i3.enable = true;

      layout = lib.mkDefault "us";
      xkbOptions = "ctrl:nocaps";
    };

    openssh = {
      enable = true;
      forwardX11 = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    acpid.enable = true;
    dbus.enable = true;
    locate.enable = true;
    timesyncd.enable = true;
  };

  security.dhparams.enable = true;

  programs = {
    adb.enable = true;
    bash.enableCompletion = true;
    fish.enable = true;
    java.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    wireshark.enable = true;
    zsh.enable = true;

    chromium = {
        enable = true;
        # Imperatively installed extensions will seamlessly merge with these.
        # Removing extensions here will remove them from chromium, no matter how
        # they were installed.
        extensions = [
          "cmedhionkhpnakcndndgjdbohmhepckk" # Adblock for Youtube™
          "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
          "jcjjhjgimijdkoamemaghajlhegmoclj" # Trezor wallet
          "ldjkgaaoikpmhmkelcgkgacicjfbofhh" # Instapaper
        ];
        homepageLocation = "https://google.com";
        defaultSearchProviderSearchURL = "https://encrypted.google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
        defaultSearchProviderSuggestURL = "https://encrypted.google.com/complete/search?output=chrome&q={searchTerms}";
    };
  };

  # Select internationalisation properties.

  nix = {
    #useSandbox = true;
    buildCores = 0;  # 0 means auto-detect number of CPUs (and use all)
    maxJobs = lib.mkDefault 10;

    extraOptions = ''
      # To not get caught by the '''"nix-collect-garbage -d" makes
      # "nixos-rebuild switch" unusable when nixos.org is down"''' issue:
      gc-keep-outputs = true
      # For 'nix-store -l $(which vim)'
      log-servers = http://hydra.nixos.org/log
      # Number of seconds to wait for binary-cache to accept() our connect()
      connect-timeout = 15
    '';

    # Automatic garbage collection
    gc.automatic = true;
    gc.dates = "03:15";
    gc.options = "--delete-older-than 14d";

    autoOptimiseStore = true;

    optimise.automatic = true;
    optimise.dates = [ "03:30" ];
  };

  sound.mediaKeys.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
