{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #urxvt_font_size
    #urxvt_perls
    autocutsel
    bashInteractive
    bridge-utils
    cifs_utils  # for mount.cifs, needed for cifs filesystems in systemd.mounts.
    coreutils
    ddrescue
    dmenu
    exfat
    exfat-utils
    fd
    fwupd
    fzf
    gitAndTools.gitSVN
    gitAndTools.hub
    gparted
    hdparm
    htop
    i7z
    iftop
    iotop
    iptables
    iputils
    lftp
    light
    lm_sensors
    lsof
    mdadm
    mpv
    ncdu
    neovim
    netcat
    nettools
    nfs-utils
    ntfs3g
    oh-my-zsh
    p7zip
    psmisc
    pv
    pwgen
    ripgrep
    rsync
    screen
    smartmontools
    syncthing
    usbutils
    vimHugeX
    vlc
    wget
    zsh
    zstd
  ];
}
