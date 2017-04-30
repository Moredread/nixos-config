{ config, lib, pkgs, ... }:

{
  imports = [
    ./base-testing.nix
    ./base-extras.nix
  ];

#  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    ansible
    aspellDicts.de
    aspellDicts.en
    blender
    bridge-utils
    chromium
    cifs_utils  # for mount.cifs, needed for cifs filesystems in systemd.mounts.
    cmake
    coreutils
    dmenu
    dmidecode
    dos2unix
    electrum
    ffmpeg
    findutils
    firefox
    freetype
    gajim
    gcc
    gitFull
    glxinfo
    gnumake
    gnupg
    google-chrome
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
    pv
    pwgen
    python27Full
    python27Packages.virtualenvwrapper
    python2nix
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
    smartmontools
    socat
    spotify
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
    wget
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
#    idea.pycharm-professional
#    nfs-utils
#    steam
#    wirelesstools
#    wireshark
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
#      displayManager.gdm.enable = true;
#      displayManager.gdm.autoLogin.enable = true;
#      displayManager.gdm.autoLogin.user = "vagrant";
    };

    openssh.enable = true;
    dbus.enable    = true;
    locate.enable = true;

    # Replace nptd by timesyncd
    timesyncd.enable = true;

    udev.extraRules = ''
    # Trezor
    SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"
    '';

    # cups, for printing documents
    printing.enable = true;
    printing.gutenprint = true; # lots of printer drivers

    avahi = {
      enable = true;
      nssmdns = true;
      # publish.enable = true;
      # publish.addresses = true;
      # publish.workstation = true;
    };

    syncthing = {
      enable = true;
      user = "addy";
      dataDir = "/home/addy/.config/syncthing";
    };
  };

  programs = {
    fish.enable = true;
    java.enable = true;
    mosh.enable = true;
#    wireshark.enable = true;
    zsh.enable = true;

    chromium = {
        enable = true;
        # Imperatively installed extensions will seamlessly merge with these.
        # Removing extensions here will remove them from chromium, no matter how
        # they were installed.
        extensions = [
          "cmedhionkhpnakcndndgjdbohmhepckk" # Adblock for Youtube™
          "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
          "jcjjhjgimijdkoamemaghajlhegmoclj" # Trezor
#          "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        ];
    };
  };

  # Select internationalisation properties.
#  i18n.consoleKeyMap = "qwertz/de";

  nix = {
    useSandbox = true;
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
  };


  environment.interactiveShellInit = ''
    # A nix query helper function
    nq()
    {
      case "$@" in
        -h|--help|"")
          printf "nq: A tiny nix-env wrapper to search for packages in package name, attribute name and description fields\n";
          printf "\nUsage: nq <case insensitive regexp>\n";
          return;;
      esac
      nix-env -qaP --description \* | grep -i "$@"
    }
    #export HISTCONTROL=ignoreboth   # ignorespace + ignoredups
    #export HISTSIZE=1000000         # big big history
    #export HISTFILESIZE=$HISTSIZE
    #shopt -s histappend             # append to history, don't overwrite it
  '';

}
