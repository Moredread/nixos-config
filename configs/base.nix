{ config, lib, pkgs, ... }:

{
  imports =
  [
    ../configs/packages.nix
  ];

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
    trezord.enable = true;

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

      displayManager.sessionCommands = '''';
      displayManager.slim = {
        enable = true;
        autoLogin  = true;
        defaultUser = "addy";
      };

      libinput.enable = true;
      #windowManager.i3.enable = true;
      #desktopManager.default = "none";
      #windowManager.default = "i3";

      desktopManager.xterm.enable = false;

      xkbOptions = "ctrl:nocaps";

      useGlamor = true;
    };

    dbus.packages = [ pkgs.blueman ];
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

    source $ZSH/oh-my-zsh.sh

    setopt extendedglob

    alias edit-nixos='nvim /etc/nixos/**/*.nix~*/home/* -p'
    alias edit-home='nvim /etc/nixos/home/**/*.nix -p'
    alias home-edit='edit-home'
    alias nixos-edit='edit-nixos'
    alias vim-update='nvim -c :PlugUpdate'
    alias vim='nvim'

    function savepath {
        pwd > ~/.last_dir
    }

    # restore last saved path
    if [ -f ~/.last_dir ]
        then cd `cat ~/.last_dir`
    fi
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

  networking.firewall.allowedUDPPorts = [ 6923 6965 1234 ]; # bittorrent + dht
  networking.firewall.allowedTCPPorts = [ 6923 6965 50001 50002 8332 1234 ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
