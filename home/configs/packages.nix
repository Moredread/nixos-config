{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #autocutsel
    #csvkit
    #darktable
    #dfeet
    #nix-du
    #nur.repos.mic92.nixpkgs-fmt
    #nur.repos.moredread.implicitcad
    alacritty
    alot
    apg
    appimage-run
    arandr
    aria2
    aspellDicts.de
    aspellDicts.en
    atool
    bc
    bind.dnsutils
    binutils
    blender
    blueman
    borgbackup
    breeze-icons
    breeze-qt5
    cachix
    calibre
    chromium
    crawl
    daemontools
    docker
    docker_compose
    dos2unix
    dpkg
    dunst
    entr
    evince
    exfat-utils
    fd
    feh
    ffmpeg
    file
    findutils
    firefox-bin
    flvstreamer
    fuse_exfat
    fzf
    gawk
    gdb
    gitAndTools.gitFull
    gitAndTools.hub
    gitAndTools.tig
    glib
    gnome3.dconf
    gnome3.dconf-editor
    gnome3.zenity
    gnugrep
    gnumake
    gnupg
    gnupg1
    gocryptfs
    google-chrome-beta
    gphoto2
    graphviz
    gsettings-qt
    handbrake
    hledger
    hledger-ui
    hledger-web
    i3lock
    imagemagick7
    inetutils
    josm
    jq
    keepassx2
    krusader
    ledger
    libav
    libreoffice
    libsmbios
    mc
    mercurialFull
    meshlab
    minecraft
    mkpasswd
    mpv
    msmtp
    msr-tools
    mumble
    mupdf
    networkmanagerapplet
    nix-prefetch-scripts
    nix-universal-prefetch
    nixos-generators
    nixos-icons
    nixpkgs-fmt
    nmap
    nox
    nur.repos.mic92.cntr
    nur.repos.mic92.inxi
    nur.repos.moredread.nix-search
    openxcom
    p7zip
    pamixer
    paperkey
    parallel
    pass-custom
    pasystray
    pavucontrol
    polkit_gnome
    posix_man_pages
    powertop
    python3Packages.mps-youtube
    python3Packages.python-language-server
    pywal
    qrencode
    qsyncthingtray
    ranger
    rclone
    ripgrep
    rls
    rnix-lsp
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
    subversion
    syncthing
    tdesktop
    tetex
    thunderbird
    todo-txt-cli
    travis
    unetbootin
    unrar
    unstable.cataclysm-dda-git
    unstable.prusa-slicer
    unstable.prusa-slicer
    unzip
    vimPlugins.fzf-vim
    vlc
    w3m
    wirelesstools
    xbrightness
    xcwd
    xorg.xev
    xsel
    you-get
    youtube-dl
    yubioath-desktop
    zip
    zotero
  ];
}
