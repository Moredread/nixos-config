{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../configs/autocutsel.nix
      ../configs/fonts.nix
      ../configs/overrides.nix
      ../configs/packages.nix
      ../configs/services.nix
      ../home/configs/overrides.nix
      #../configs/build.nix
      <home-manager/nixos>
      #(builtins.fetchGit https://github.com/edolstra/dwarffs + "/module.nix")
    ];

  boot = {
    kernelPackages = if config.virtualisation.virtualbox.host.enable then
      pkgs.linuxPackages else pkgs.linuxPackages_latest;
    #crashDump.enable = true;
    #bootchart.enable = true;

    # Dell 9370 needs it to not drain during sleep
    kernelParams = [
      "mem_sleep_default=deep"
      #"i915.modeset=1" # entirely absent in nixos-hardware
      #"i915.enable_guc=2" # entirely absent in nixos-hardware
      #"i915.enable_gvt=1" # entirely absent in nixos-hardware
      #"i915.enable_psr=1" # entirely absent in nixos-hardware
      #"i915.fastboot=1" # entirely absent in nixos-hardware
      #"i915.enable_rc6=0"

      #"i915.enable_fbc=1" # set to 2 in nixos-hardware
    ];
    kernel.sysctl = { "net.core.default_qdisc" = "fq_codel"; };

    initrd.availableKernelModules = [
      "aes_x86_64"
      "aesni_intel"
      "bfq"
      "cryptd"
      "crypto_simd"
      "ghash_clmulni_intel"
    ];

    cleanTmpDir = true;
    tmpOnTmpfs = true;

    loader.grub = {
      ipxe.netboot-xyz = ''
        #!ipxe
        dhcp
        chain --autofree https://boot.netboot.xyz
      '';
    };
    supportedFilesystems = [ "cifs" "nfs" ];
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

  # For Steam
  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=30s
  '';

  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  virtualisation.docker.extraOptions = "--bip 172.26.0.1/16"; # The default subnet is used by a wifi spot near me :/

  hardware = {
    # Which works?
    acpilight.enable = true;
    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;
    brightnessctl.enable = true;
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    ledger.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true; # This might be needed for Steam games
    #pulseaudio.zeroconf.discovery.enable = true;
    pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
    u2f.enable = true;
    #sane.enable = true; # scanner support
    #sane.snapshot = true;
    #sane.netConf = "192.168.42.123";
  };

  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      Defaults timestamp_type = global
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
    EDITOR = pkgs.lib.mkOverride 0 "${pkgs.neovim}/bin/nvim";
  };

  security.dhparams.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    adb.enable = true;
    bash.enableCompletion = true;
    command-not-found.enable = true;
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
    '';

    trustedUsers = [ "addy" "root" ];

    binaryCaches = [
      #"https://cache.nixos.org"
      #"https://moredread.cachix.org"
      "https://moredread-nur.cachix.org"
    ];
    binaryCachePublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "moredread.cachix.org-1:b3WX9qj9AwcxVaJESfNSkw0Ia+oyxx6zDxfnoc0twDE=" "moredread-nur.cachix.org-1:+kDrC3wBtV/FgGi8/SFsQXNFJsdArgvOas/BvmXQVxE=" ];

    distributedBuilds = true;
  };

  home-manager.users.addy = { pkgs, ... }: {
    imports = [
      ../home/home.nix
    ];

    nixpkgs.config.allowUnfree = true;
  };

  networking.firewall.allowedUDPPorts = [ 6923 6965 1234 1900 4380 ];
  networking.firewall.allowedTCPPorts = [
    6923
    6965
    50001
    50002
    8332
    1234
    1900
    22000
    4070 #spotify
  ];
  networking.firewall.extraCommands = ''
    iptables -A INPUT -m pkttype --pkt-type multicast -j nixos-fw
  '';

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
