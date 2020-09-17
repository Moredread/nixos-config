{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      #font-awesome_4
      corefonts # Microsoft free fonts
      dejavu_fonts
      fira
      fira-mono
      unstable.line-awesome
      google-fonts
      inconsolata # monospaced
      libertine
      mononoki
      nerdfonts
      open-dyslexic
      overpass
      oxygenfonts
      powerline-fonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      ttf_bitstream_vera
      ubuntu_font_family # Ubuntu fonts
      unifont # some international languages
    ];
    fontconfig = {
      hinting.autohint = true;
      antialias = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];
      };
    };
  };
}
