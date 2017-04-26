{ config, lib, pkgs, ... }:

{
  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;

  nix = {
    buildCores = 4;
    maxJobs = 4;
  };

  nixpkgs.config.allowUnfree = true;

  # Packages for Vagrant
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.de
    aspellDicts.en
    coreutils
    dmenu
    findutils
    firefox
    gitAndTools.gitFull
    google-chrome
    i3lock
    i3status
    iftop
    ioping
    iotop
    iputils
    jq
    neovim
    netcat
    nettools
    nfs-utils
    nix-zsh-completions
    oh-my-zsh
    python27Full
    python27Packages.virtualenvwrapper
    python35Full
    python35Packages.virtualenvwrapper
    ripgrep
    rsync
    rxvt_unicode
    screen
    skype
    sloccount
    socat
    solfege
    spice
    spotify
    vimHugeX
    wpa_supplicant
    wpa_supplicant_gui
    xsel
    youtube-dl
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-navigation-tools
    zsh-syntax-highlighting
  ];

  fonts = {
    fonts = with pkgs; [
#     corefonts  # Micrsoft free fonts
      dejavu_fonts
      google-fonts
      inconsolata  # monospaced
      source-code-pro
      source-sans-pro
      source-serif-pro
      ttf_bitstream_vera
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };
      ultimate = {
        enable = false;
      };
    };
  };

  services = {
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.autoLogin.enable = true;
      displayManager.gdm.autoLogin.user = "vagrant";
    };

    openssh.enable = true;
    dbus.enable    = true;

    # Replace nptd by timesyncd
    timesyncd.enable = true;
  };

  programs = {
    zsh.enable = true;
  };


}
