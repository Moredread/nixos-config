{ config, lib, pkgs, ... }:

let
  nur-no-pkgs = import /home/addy/nur/default.nix {};
in {
  imports =
  [
    ../configs/autocutsel.nix
    ../configs/fonts.nix
    ../configs/overrides.nix
    ../configs/packages.nix
    ../configs/services.nix
    ../home/configs/overrides.nix
    #(builtins.fetchGit https://github.com/edolstra/dwarffs + "/module.nix")
    nur-no-pkgs.modules.lenovo-throttling-fix
  ];

  services.lenovo-throttling-fix.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # Dell 9370 needs it to not drain during sleep
    kernelParams = [ "mem_sleep_default=deep" ];

    cleanTmpDir = true;
    tmpOnTmpfs = true;

    loader.grub = {
      ipxe.netboot-xyz = ''
        #!ipxe
        dhcp
        chain --autofree https://boot.netboot.xyz
      '';
    };
    supportedFilesystems = [ "nfs" "cifs" ];
  };

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable";
    wifi.powersave = true;
  };

  time.timeZone = "Europe/Berlin";

  # For Steam
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions = "--bip 172.26.0.1/16"; # The default subnet is used by a wifi spot near me :/

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
    };
  };

  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      Defaults !tty_tickets
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  environment.enableDebugInfo = true;
  environment.variables = {
      EDITOR = pkgs.lib.mkOverride 0 "nvim";
  };

  security.dhparams.enable = true;

  programs = {
    adb.enable = true;
    bash.enableCompletion = true;
    command-not-found.enable = true;
    dconf.enable = true;
    #java.enable = true;
    mosh.enable = true;
    #mtr.enable = true;
    #wireshark.enable = true;

    # https://www.reddit.com/r/linuxquestions/comments/56jdxx/ohmyzsh_under_nixos/
    # I'd rather have it in my home config, but I like it installed for all my
    # users...
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
    alias git="${pkgs.gitAndTools.hub}/bin/hub"

    alias n='pushd /etc/nixos'
    alias v='nvim'
    alias update='sudo sh -c "nix-channel --update"; rm -rf ~/.nix-defexpr; mkdir -p ~/.nix-defexpr; ln -s /nix/var/nix/profiles/per-user/root/channels ~/.nix-defexpr/channels'
    alias upgrade='sudo sh -c "nixos-rebuild switch"; home-manager switch'
    alias build='nixos-rebuild build; home-manager build'

    alias cdn="pushd /etc/nixos"

    function savepath {
      pwd > ~/.last_dir
    }

    function f {
      find $2 -iname "*$1*"
    }

    function nix-run {
      nix-shell -p $1 --run "$*"
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
    #package = pkgs.nixUnstable;

    useSandbox = true;
    buildCores = lib.mkDefault 0;
    maxJobs = lib.mkDefault 8;

    extraOptions = ''
      gc-keep-outputs = true
      connect-timeout = 15
	  builders-use-substitutes = true
    '';

    trustedUsers = [ "addy" ];

    binaryCaches = [ "https://cache.nixos.org" "https://moredread.cachix.org" "https://moredread-nur.cachix.org" ];
    binaryCachePublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "moredread.cachix.org-1:b3WX9qj9AwcxVaJESfNSkw0Ia+oyxx6zDxfnoc0twDE=" "moredread-nur.cachix.org-1:+kDrC3wBtV/FgGi8/SFsQXNFJsdArgvOas/BvmXQVxE=" ];

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "aarch64.nixos.community";
        maxJobs = 64;
        sshKey = "/root/.ssh/id_ed25519";
        sshUser = "moredread";
        system = "aarch64-linux";
        supportedFeatures = [ "big-parallel" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 6923 6965 1234 1900 4380] ++ lib.range 27000 27036; # bittorrent + dht
  networking.firewall.allowedTCPPorts = [ 6923 6965 50001 50002 8332 1234 1900 ] ++ lib.range 27000 27036;

  # For wg-quick VPN
  networking.firewall.checkReversePath = "loose";

  #networking.firewall.enable = false;
  #networking.firewall.logRefusedPackets = true;


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
