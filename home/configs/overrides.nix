{ pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> {};
  overlay = self: super: {
    slic3r-prusa3d = unstable.slic3r-prusa3d.overrideAttrs (oldAttrs: {
      version = "1.40.0-alpha1";
      src = self.pkgs.fetchFromGitHub {
        owner = "prusa3d";
        repo = "Slic3r";
        sha256 = "0npbrwnzcpr26i3r9hspqiq89yxf763sf71r72br6dw3nrj1wdwi";
        rev = "version_1.40.0-alpha1";
      };
      buildInputs = oldAttrs.buildInputs ++ [ self.curl ];
      postInstall = ''
        echo 'postInstall'
        wrapProgram "$out/bin/slic3r-prusa3d" \
        --prefix PERL5LIB : "$out/lib/slic3r-prusa3d:$PERL5LIB"

        # it seems we need to copy the icons...
        mkdir -p $out/bin/var
        cp -r ../resources/icons/* $out/bin/var/
        cp -r ../resources $out/bin/
      '';
    });
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
