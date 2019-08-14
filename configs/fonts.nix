{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts  # Microsoft free fonts
      #font-awesome_4
      dejavu_fonts
      fira
      fira-mono
      google-fonts
      inconsolata  # monospaced
      libertine
      mononoki
      overpass
      oxygenfonts
      powerline-fonts
      nerdfonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      ttf_bitstream_vera
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
    ];
    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };
      ultimate.enable = true;
      penultimate.enable = true;
    };
  };
}
