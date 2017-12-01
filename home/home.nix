{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
  electrum3 = pkgs.callPackage ./pkgs/electrum3.nix {};
in {
  imports = [
    configs/wm.nix
  ];

  home.keyboard.layout = "de";
  home.language = {
    paper = "de";
    monetary = "de";
    address = "de";
  };

  home.packages = with pkgs; [
    apg
    aria2
    aspellDicts.de
    aspellDicts.en
    atool
    autocutsel
    bind.dnsutils
    blender
    borgbackup
    borgbackup
    calibre
    daemontools
    dmidecode
    dropbox
    dunst
    electrum3
    evince
    ffmpeg
    findutils
    firefox-bin
    flvstreamer
    gitAndTools.gitFull
    gitAndTools.gitSVN
    gitAndTools.hub
    gitFull
    glxinfo
    gnupg
    gnupg1
    gource
    i3lock
    i3status
    idea.pycharm-professional
    kate
    kdiff3
    keepassx2
    kget
    krename
    krusader
    libreoffice
    love
    mercurialFull
    minecraft
    mplayer
    mpv
    mumble
    neovim
    networkmanagerapplet
    nixops
    nmap
    nox
    p7zip
    paperkey
    pavucontrol
    polkit_gnome
    posix_man_pages
    powertop
    profanity
    python36Packages.virtualenv
    python3Packages.mps-youtube
    ranger
    rclone
    ripgrep
    rsync
    rxvt_unicode
    screen
    skype
    sloccount
    socat
    speedtest-cli
    spotify
    steam
    subversion
    syncthing
    syncthing-inotify
    taskwarrior
    telnet
    thunderbird
    udiskie
    unrar
    unzip
    vlc
    xbrightness
    xorg.xbacklight
    xorg.xvinfo
    xpdf
    xsel
    youtube-dl
    yubioath-desktop
    zip
  ];

  programs = {
    home-manager.enable = true;
    home-manager.path = https://github.com/rycee/home-manager/archive/release-17.09.tar.gz;

    browserpass.enable = true;
    htop.enable = true;
    #htop.detailedCpuTime = true;
    #htop.treeView = true;
    lesspipe.enable = true;
    man.enable = true;
    neovim.enable = true;
  };
}
