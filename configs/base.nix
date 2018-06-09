{ config, lib, pkgs, ... }:

{
  imports =
  [
    ../configs/fonts.nix
    ../configs/overrides.nix
    ../configs/packages.nix
    ../home/configs/overrides.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

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

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable";
  };

  time.timeZone = "Europe/Berlin";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

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
    #sane.snapshot = true;
    #sane.netConf = "192.168.42.123";
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

    #flatpak.enable = true;

    fwupd.enable = true;
    acpid.enable = true;
    dbus.enable = true;
    locate.enable = true;
    # mkDefault, so that it works with VM
    timesyncd.enable = lib.mkDefault true;
    thermald.enable = true;
    pcscd.enable = true;
    trezord.enable = true;

    udev.extraRules = with pkgs; ''
    # Trezor
    SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

    # set scheduler for non-rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="noop"

    # give user permission to change brightness
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    # cups, for printing documents
    printing.enable = true;
    printing.drivers = with pkgs; [ gutenprint hplip ];

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
      openDefaultPorts = true;
      user = "addy";
      dataDir = "/home/addy/.config/syncthing";
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

      inputClassSections = [
        ''
          Identifier "BT mouse"
          MatchDriver "libinput"
          MatchProduct "BM30X mouse"
          Option "AccelSpeed" "-0.5"
        ''
      ];
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
    serviceConfig.RestartSec = 10;
    serviceConfig.StartLimitIntervalSec = 60;
    serviceConfig.StartLimitBurst = 3;
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD -fork";
  };

  systemd.user.services."autocutsel-primary" = {
    enable = true;
    description = "AutoCutSel for PRIMARY buffer";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 10;
    serviceConfig.StartLimitIntervalSec = 60;
    serviceConfig.StartLimitBurst = 3;
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork";
  };

  security.dhparams.enable = true;

  programs = {
    #adb.enable = true;
    bash.enableCompletion = true;
    command-not-found.enable = true;
    dconf.enable = true;
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
    plugins=( git history mosh pep8 python screen rsync sudo systemd ssh-agent docker docker-compose aws github )

    source $ZSH/oh-my-zsh.sh

    setopt extendedglob

    alias vim='nvim'
    alias edit-nixos='nvim /etc/nixos/**/*.nix~*/home/* -p'
    alias edit-home='nvim /etc/nixos/home/**/*.nix -p'
    alias home-edit='edit-home'
    alias nixos-edit='edit-nixos'
    alias he='edit-home'
    alias ne='edit-nixos'
    alias vim-update='vim -c :PlugUpdate'
    alias rwifi='sudo sh -c "modprobe ath10k_pci -v -r; sleep 5; modprobe ath10k_pci -v"'
    alias t='${pkgs.todo-txt-cli}/bin/todo.sh -t'
    alias qrsel='${pkgs.qrencode}/bin/qrencode -l H -t ANSIUTF8 `${pkgs.xsel}/bin/xsel`'

    alias ip="ip --color"
    alias 4="ip -4"
    alias 6="ip -6"

    alias x="${pkgs.atool}/bin/atool -x"


    alias ncd='pushd /etc/nixos'
    alias v='nvim'
    alias update='sudo sh -c "nix-channel --update"; mkdir -p ~/.nix-defexpr; rm -f ~/.nix-defexpr/channels; ln -s /nix/var/nix/profiles/per-user/root/channels ~/.nix-defexpr/channels'
    alias upgrade='sudo sh -c "nixos-rebuild switch"; home-manager switch'

    alias cdn="pushd /etc/nixos"

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
        #enable = true;
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
    package = pkgs.nixUnstable;

    useSandbox = true;
    buildCores = lib.mkDefault 0;
    maxJobs = lib.mkDefault 8;

    extraOptions = ''
      gc-keep-outputs = true
      connect-timeout = 15
    '';

    #autoOptimiseStore = true;
  };

  networking.firewall.allowedUDPPorts = [ 6923 6965 1234 1900 ]; # bittorrent + dht
  networking.firewall.allowedTCPPorts = [ 6923 6965 50001 50002 8332 1234 1900 ];
  #networking.firewall.enable = false;
  #networking.firewall.logRefusedPackets = true;
  networking.firewall.checkReversePath = "loose";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
