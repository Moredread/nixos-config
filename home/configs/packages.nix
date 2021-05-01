{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #(import ./emacs.nix { inherit pkgs; })
    #autocutsel
    #dfeet
    #k2pdfopt
    #mercurialFull
    #nur-unstable.repos.mic92.cntr
    #nur-unstable.repos.mic92.nix-update
    #rls
    #rnix-lsp
    age
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
    checkbashism
    chromium
    csvkit
    daemontools
    darktable
    docker
    docker_compose
    dos2unix
    dosfstools # for gparted
    dpkg
    duc
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
    freecad
    fuse_exfat
    fzf
    gawk
    gdb
    git-quick-stats
    gitAndTools.gitFull
    gitAndTools.hub
    gitAndTools.tig
    glib
    gnome3.dconf
    gnome3.dconf-editor
    gnome3.gsettings-desktop-schemas
    gnome3.zenity
    gnugrep
    gnumake
    gnupg
    gnupg1
    gocryptfs
    gopass
    gphoto2
    graphviz
    gsettings-desktop-schemas
    gsettings-qt
    handbrake
    hledger
    hledger-ui
    hledger-web
    i3lock
    imagemagick7
    inetutils
    inkscape
    josm
    jq
    keepassx2
    ledger
    libreoffice
    libsmbios
    lutris
    mc
    mkpasswd
    mpv
    msmtp
    msr-tools
    mtools # for gparted
    mumble
    networkmanagerapplet
    nix-du
    nix-index
    nix-prefetch-scripts
    nix-universal-prefetch
    nixos-generators
    nixos-icons
    nixpkgs-fmt
    nmap
    nox
    nur.repos.moredread.joplin-desktop
    nur.repos.moredread.nix-search
    p7zip
    pamixer
    paperkey
    parallel
    pasystray
    pavucontrol
    polkit_gnome
    posix_man_pages
    powertop
    python3Packages.python-language-server
    qrencode
    qsyncthingtray
    ranger
    rclone
    reptyr
    ripgrep
    ripgrep-all
    rsync
    s-tui
    screen
    scrot
    shellcheck
    sloccount
    sops
    speedtest-cli
    spotify
    sshfs
    steam
    syncthing
    thunderbird-bin
    todo-txt-cli
    travis
    unrar
    unstable.peep
    unzip
    v4l-utils
    vimPlugins.YouCompleteMe
    vimPlugins.fzf-vim
    vlc
    vulkan-tools
    w3m
    wireguard
    wirelesstools
    xbrightness
    xcwd
    xorg.xev
    xsel
    you-get
    youtube-dl
    yubioath-desktop
    zfs
    zip
    zotero
  ];
}
