{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./base.nix
    ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    aria2
    blender
    blink
    borgbackup
    chromium
    dropbox
    firefox-bin
    gajim
    gimp
    gnucash
    imagemagick
    kdiff3
    keepassx2
    libreoffice
    light
    profanity
    qsyncthingtray
    rclone
    redshift
    skype
    spark
    speedtest-cli
    spotify
    steam
    syncthing
    syncthing-inotify
    thunderbird
    xorg.xbacklight
    zdfmediathk
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
    thermald.enable = true;

    udev.extraRules = ''
    # Trezor
    SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"

    # set deadline scheduler for non-rotating disks
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
      temperature.night = 3500;
    };

    xserver = {
      libinput = {
        enable = true;
      };

      enable = true;

      windowManager.i3.enable = true;

      layout = lib.mkDefault "us";
      xkbOptions = "ctrl:nocaps";
    };

  };

  i18n.consoleKeyMap = lib.mkDefault "de";

  virtualisation.virtualbox.host.enable = true;
#  virtualisation.virtualbox.host.enableHardening = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true; # This might be needed for Steam games
    pulseaudio.zeroconf.discovery.enable = true;
    sane.enable = true; # scanner support
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec { 
      gajim = pkgs.gajim.override { enableNotifications = true; };
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
}
