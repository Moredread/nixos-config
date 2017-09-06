{ config, lib, pkgs, ... }:

{
  imports = [
    #./base-testing.nix
    #./base-extras.nix
  ];

  boot.cleanTmpDir = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      fira
      fira-mono
      google-fonts
      inconsolata  # monospaced
      mononoki
      overpass
      oxygenfonts
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

  virtualisation.virtualbox.host.enable = true;

  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true; # This might be needed for Steam games
    pulseaudio.zeroconf.discovery.enable = true;
    #sane.enable = true; # scanner support
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      gajim = pkgs.gajim.override { enableNotifications = true; };
      # gutenprint = pkgs.gutenprint.overrideAttrs (attrs: {
      #   src = pkgs.fetchurl {
      #     url = "mirror://sourceforge/gimp-print/gutenprint-5.2.13.tar.bz2";
      #     sha256 = "0hi7s0y59306p4kp06sankfa57k2805khbknkvl9d036hdfp9afr";
      #   };
      # });
      # temporary fix until tray support is available in upstream
      profanity = pkgs.lib.overrideDerivation pkgs.profanity (attrs: {
        buildInputs = attrs.buildInputs ++ [ pkgs.gnome2.gtk ];
      });
    };
    profanity.traySupport = true;
    chromium = {
#      enableWideVine = true;
    };
  };

  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
      EDITOR = pkgs.lib.mkOverride 0 "vim";
  };

  environment.systemPackages = with pkgs; [
    #ansible
    aria2
    aspellDicts.de
    aspellDicts.en
    autocutsel
    bashInteractive
    blender
    #blink
    #borgbackup
    #bridge-utils
    chromium
    cifs_utils  # for mount.cifs, needed for cifs filesystems in systemd.mounts.
    coreutils
    dmenu
    #dmidecode
    docker_compose
    dos2unix
    dropbox
    #electrum
    evince
    exfat
    exfat-utils
    ffmpeg
    findutils
    firefox-bin
    #freetype
    gimp
    gitFull
    glxinfo
    gnucash
    gnupg
    gnupg1
    #gource
    gparted
    hdparm
    flvstreamer
    htop
    gitAndTools.hub
    i3lock
    i3status
    i7z
    iftop
    #imagemagick
    #ioping
    iotop
    iptables
    iputils
    kdiff3
    keepassx2
    libreoffice
    light
    lm_sensors
    lsof
    mdadm
    #mercurialFull
    mpv
    #mumble
    ncdu
    neovim
    netcat
    nettools
    networkmanagerapplet
    #nix-zsh-completions
    #nmap
    nox
    ntfs3g
    oh-my-zsh
    openvpn
    p7zip
    parted
    pavucontrol
    #pkgconfig
    polkit_gnome
    posix_man_pages
    powertop
    profanity
    psmisc
    pv
    pwgen
    python27Full
    python27Packages.virtualenvwrapper
    python2nix
    python35Full
    python35Packages.ipython
    python35Packages.neovim
    qsyncthingtray
    ranger
    #rclone
    #redshift
    ripgrep
    rsync
    rxvt_unicode
    screen
    skype
    #sloccount
    smartmontools
    #socat
    speedtest-cli
    spotify
    #steam
    #subversion
    syncthing
    syncthing-inotify
    #telnet
    thunderbird
    udiskie
    unrar
    unzip
    urxvt_font_size
    urxvt_perls
    #vagrant
    vimHugeX
    vlc
    wget
    xorg.xbacklight
    xbrightness
    #xpdf
    xsel
    youtube-dl
    zdfmediathk
    zsh
    #zsh-autosuggestions
    #zsh-completions
    #zsh-navigation-tools
    #zsh-syntax-highlighting
    zstd
    #idea.pycharm-professional
    #nfs-utils
  ];

  services = {
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
    # mkDefault, so that it works with VM
    timesyncd.enable = lib.mkDefault true;
    thermald.enable = true;

    udev.extraRules = ''
    # Trezor
    SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

    # set scheduler for non-rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="noop"
    '';

    # cups, for printing documents
    printing.enable = true;
    printing.gutenprint = true; # lots of printer drivers

    avahi = {
      enable = true;
      nssmdns = true;
      ipv6 = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
    };

    syncthing = {
      enable = true;
      useInotify = true;
      openDefaultPorts = true;
      user = "addy";
      dataDir = "/home/addy/.config/syncthing";
    };

    redshift = {
      enable = false;
      latitude = "49.417";
      longitude = "8.717";
      temperature.day = 6500;
      temperature.night = 3800;
    };

    xserver = {
      enable = true;

      libinput.enable = true;
      windowManager.i3.enable = true;

      xkbOptions = "ctrl:nocaps";

      useGlamor = true;
    };


  };

  # adapted from https://gist.github.com/joedicastro/a19a9dfd21470783240c739657747f5d
  systemd.user.services."autocutsel-clipboard" = {
    enable = true;
    description = "AutoCutSel for CLIPBOARD buffer";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD -fork";
  };

  systemd.user.services."autocutsel-primary" = {
    enable = true;
    description = "AutoCutSel for PRIMARY buffer";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork";
  };

  security.dhparams.enable = true;

  programs = {
    #adb.enable = true;
    bash.enableCompletion = true;
    #fish.enable = true;
    #java.enable = true;
    mosh.enable = true;
    #mtr.enable = true;
    #wireshark.enable = true;

    # https://www.reddit.com/r/linuxquestions/comments/56jdxx/ohmyzsh_under_nixos/
    zsh.enable = true;
    zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    COMPLETION_WAITING_DOTS="true"

    zstyle :omz:plugins:ssh-agent identities id_ed25519 id_rsa sfb_key

    # Customize your oh-my-zsh options here
    ZSH_THEME="agnoster"
    plugins=(git history mosh pep8 python screen rsync sudo systemd ssh-agent docker docker-compose aws github)

    alias nixos-edit='vim /etc/nixos/**/*.nix -p'
    alias vim-update='vim -c :PlugUpdate'

    source $ZSH/oh-my-zsh.sh
    '';

    zsh.promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh

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

  nix = {
    useSandbox = true;
    buildCores = 0;  # 0 means auto-detect number of CPUs (and use all)
    maxJobs = lib.mkDefault 4;

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

    #optimise.automatic = true;
    #optimise.dates = [ "03:30" ];
  };

  networking.firewall.allowedUDPPorts = [ 6923 6965 ]; # bittorrent + dht
  networking.firewall.allowedTCPPorts = [ 6923 6965 ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
