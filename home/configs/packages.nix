{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    alot
    apg
    appimage-run
    arandr
    aria2
    aspellDicts.de
    aspellDicts.en
    atool
    autocutsel
    bind.dnsutils
    binutils
    blueman
    borgbackup
    breeze-icons
    breeze-qt5
    btrfs-dedupe
    cachix
    calibre
    crawl
    crawlTiles
    daemontools
    dfeet
    direnv
    docker
    docker_compose
    dos2unix
    dpkg
    dunst
    evince
    exfat-utils
    fd
    feh
    ffmpeg
    file
    findutils
    firefox-bin
    flvstreamer
    freecad
    fuse_exfat
    fzf
    gawk
    gdb
    gitAndTools.gitFull
    gitAndTools.hub
    gitwatch
    gnome3.dconf
    gnome3.dconf-editor
    gnugrep
    gnumake
    gnupg
    gnupg1
    graphviz
    i3lock
    inetutils
    jq
    keepassx2
    krusader
    libreoffice
    libsmbios
    mc
    mercurialFull
    minecraft
    mkpasswd
    mpv
    msr-tools
    mumble
    mupdf
    neovim
    networkmanagerapplet
    nix-du
    nix-prefetch-scripts
    nixos-icons
    nmap
    nox
    nur.repos.kalbasit.nixify
    nur.repos.mic92.inxi
    nur.repos.moredread.croc
    nur.repos.moredread.latte
    nur.repos.moredread.slic3r-prusa3d-latest
    p7zip
    pamixer
    paperkey
    pass-otp
    pasystray
    pavucontrol
    polkit_gnome
    posix_man_pages
    powertop
    python36Packages.python-language-server
    python3Packages.mps-youtube
    pywal
    qrencode
    qsyncthingtray
    ranger
    renoise
    ripgrep
    rsync
    s-tui
    screen
    scrot
    shellcheck
    skype
    sloccount
    speedtest-cli
    spotify
    sshfs
    steam
    stress
    stress-ng
    subversion
    syncthing
    taskwarrior
    thunderbird
    todo-txt-cli
    unrar
    unstable.slic3r-prusa3d
    unzip
    vimPlugins.fzf-vim
    vlc
    w3m
    xbrightness
    xorg.xev
    xpdf
    xsel
    you-get
    youtube-dl
    yubioath-desktop
    zip
  ];
}
