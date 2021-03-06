{ config, lib, pkgs, ... }:
let
  dockerConfig = pkgs.writeText "daemon.json" (builtins.toJSON {
    ipv6 = true;
    fixed-cidr-v6 = "fd00::/80";
    features = { buildkit = true; };
  });
in
{
  imports =
    [
      #(builtins.fetchGit https://github.com/edolstra/dwarffs + "/module.nix")
      #../configs/wireguard.nix
      ../configs/autocutsel.nix
      ../configs/build.nix
      ../configs/fonts.nix
      ../configs/overrides.nix
      ../configs/packages.nix
      ../configs/services.nix
      ../configs/users-and-groups.nix
      ../home/configs/overrides.nix
      <home-manager/nixos>
    ];

  boot = {
    # Dell 9370 needs it to not drain during sleep
    kernelParams = [
      #"mem_sleep_default=deep"
      #"i915.modeset=1" # entirely absent in nixos-hardware
      #"i915.enable_guc=2" # entirely absent in nixos-hardware
      #"i915.enable_gvt=1" # entirely absent in nixos-hardware
      #"i915.enable_psr=1" # entirely absent in nixos-hardware
      #"i915.fastboot=1" # entirely absent in nixos-hardware
      #"i915.error_capture=1"
      "intel_idle.max_cstate=1"
      "i915.enable_dc=0"
      "msr.allow_writes=on" # msr writes are disabled/warned about since 5.9 https://github.com/erpalma/throttled/issues/215

      #"i915.enable_fbc=1" # set to 2 in nixos-hardware
    ];
    #kernel.sysctl = { "net.core.default_qdisc" = "fq_codel"; };

    #kernelPackages = pkgs.linuxPackages_latest;

    # not sure if everything is needed
    initrd.availableKernelModules = [
      "bfq"
    ] ++ config.boot.initrd.luks.cryptoModules;

    cleanTmpDir = true;
    tmpOnTmpfs = true;
    devShmSize = "75%";

    loader.grub = {
      ipxe.netboot-xyz = ''
        #!ipxe
        dhcp
        chain --autofree https://boot.netboot.xyz
      '';
    };
    supportedFilesystems = [ "cifs" "nfs" "zfs" ];
    blacklistedKernelModules = lib.singleton "dvb_usb_rtl28xxu";
  };

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable";
    wifi.powersave = true;
    # not sure if this is necessary
    extraConfig = ''
      [connection]
      tc.qdiscs=fq_codel
    '';
  };

  time.timeZone = "Europe/Berlin";

  # For Steam and for stopping hanging a X11 server quicker when shutting down
  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=30s
  '';

  #virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  virtualisation.docker.extraOptions = ''
      --bip 172.26.0.1/16 \
      --config-file=${dockerConfig}
    ''; # The default subnet is used by a wifi spot near me :/

  hardware = {
    acpilight.enable = true;
    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    ledger.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.zeroconf.discovery.enable = true;
    #pulseaudio.zeroconf.publish.enable = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true; # This might be needed for Steam games
    pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
    pulseaudio.daemon.config = {
      default-sample-channels = 6;
    };
  };

  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      Defaults timestamp_type = global
      Defaults timestamp_timeout = 360
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

  i18n.defaultLocale = "en_US.UTF-8";

  console.font = "Lat2-Terminus16";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  environment.enableDebugInfo = true;
  environment.variables = {
    EDITOR = pkgs.lib.mkOverride 0 "${pkgs.neovim}/bin/nvim";
  };

  security.dhparams.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    adb.enable = true;
    bash.enableCompletion = true;
    command-not-found.enable = false;
    dconf.enable = true;
    #java.enable = true;
    mosh.enable = true;
    #mtr.enable = true;
    #wireshark.enable = true;

    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
    '';

    nano.syntaxHighlight = true;

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
    autoOptimiseStore = true;

    extraOptions = ''
      gc-keep-outputs = true
      connect-timeout = 15
      builders-use-substitutes = true
      #experimental-features = nix-command flakes
    '';

    trustedUsers = [ "addy" "root" ];
  };

  home-manager.users.addy = { pkgs, ... }: {
    imports = [
      ../home/home.nix
    ];

    nixpkgs.config.allowUnfree = true;
  };

  networking.firewall.allowedUDPPorts = [
    1234
    1900
    4380
    6923
    6965
  ];

  networking.firewall.allowedTCPPorts = [
    1234
    1900
    4070 #spotify
    6923
    6965
    8332
    22000
    30005
    30975
    50001
    50002
  ];

  networking.firewall.allowedTCPPortRanges = [ { from = 27000; to = 27036; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 27000; to = 27036; } ];

  xdg.portal.enable = true;

  # For wg-quick VPN
  networking.firewall.checkReversePath = "loose";

  #networking.firewall.enable = false;
  #networking.firewall.logRefusedPackets = true;

  zramSwap.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
