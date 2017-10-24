{ config, lib, pkgs, ... }:

{
  boot = {
    cleanTmpDir = true;
    tmpOnTmpfs = true;

    loader.grub = {
      ipxe.netboot-xyz = ''
        #!ipxe
        dhcp
        chain --autofree https://boot.netboot.xyz
      '';
    };
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  fonts = {
    enableDefaultFonts = true;
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
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };
      ultimate.enable = true;
      penultimate.enable = true;
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
      profanity = pkgs.lib.overrideDerivation pkgs.profanity (attrs: {
        buildInputs = attrs.buildInputs ++ [ pkgs.python3 ];
        enableParallelBuilding = true;
      });
    };
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
      EDITOR = pkgs.lib.mkOverride 0 "nvim";
  };

  environment.systemPackages = with pkgs; [
    #ansible
    #blink
    #borgbackup
    #bridge-utils
    #dmidecode
    #electrum
    #freetype
    #gource
    #idea.pycharm-professional
    #imagemagick
    #ioping
    #mercurialFull
    #mumble
    #nfs-utils
    #nix-zsh-completions
    #nmap
    #pkgconfig
    #rclone
    #redshift
    #sloccount
    #socat
    #steam
    #subversion
    #telnet
    #vagrant
    #xpdf
    #zsh-autosuggestions
    #zsh-completions
    #zsh-navigation-tools
    #zsh-syntax-highlighting
    aria2
    aspellDicts.de
    aspellDicts.en
    autocutsel
    bashInteractive
    blender
    borgbackup
    chromium
    cifs_utils  # for mount.cifs, needed for cifs filesystems in systemd.mounts.
    coreutils
    dmenu
    docker_compose
    dos2unix
    dropbox
    electrum
    evince
    exfat
    exfat-utils
    ffmpeg
    findutils
    firefox-bin
    flvstreamer
    gimp
    gitAndTools.hub
    gitFull
    glxinfo
    gnucash
    gnupg
    gnupg1
    gparted
    hdparm
    htop
    i3lock
    i3status
    i7z
    iftop
    iotop
    iptables
    iputils
    kdiff3
    keepassx2
    lftp
    libreoffice
    light
    lm_sensors
    lsof
    mdadm
    mpv
    ncdu
    neovim
    netcat
    nettools
    networkmanagerapplet
    nixops
    nox
    ntfs3g
    oh-my-zsh
    openvpn
    p7zip
    parted
    pavucontrol
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
    ripgrep
    rsync
    rxvt_unicode
    screen
    skype
    smartmontools
    speedtest-cli
    spotify
    syncthing
    syncthing-inotify
    telnet
    thunderbird
    udiskie
    unrar
    unzip
    urxvt_font_size
    urxvt_perls
    vimHugeX
    vlc
    wget
    xbrightness
    xorg.xbacklight
    xsel
    youtube-dl
    zdfmediathk
    zsh
    zstd
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
    pcscd.enable = true;

    udev.extraRules = ''
    # Trezor
    SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

    # set scheduler for non-rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="noop"
    '';

    # cups, for printing documents
    printing.enable = true;
    printing.drivers = [ pkgs.gutenprint ];

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

      displayManager.lightdm = {
        enable = true;
        autoLogin.enable = true;
        autoLogin.user = "addy";
      };

      libinput.enable = true;
      windowManager.i3.enable = true;
      desktopManager.default = "none";
      windowManager.default = "i3";

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
    command-not-found.enable = true;
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
    #gc.automatic = true;
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

  # Testing nesting configs
  nesting.clone = [
    {
      system.nixosLabel = "no-sandbox";
      nix.useSandbox = lib.mkForce false;
    }
  ];
}
