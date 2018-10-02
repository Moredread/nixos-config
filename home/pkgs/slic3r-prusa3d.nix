{ stdenv, fetchFromGitHub, makeWrapper, which, cmake, perl, perlPackages,
  boost, tbb, wxGTK30, pkgconfig, gtk3, fetchurl, gtk2, libGLU,
  glew, eigen, curl, gtest, nlopt, pcre, xorg }:
let
  AlienWxWidgets = perlPackages.buildPerlPackage rec {
    name = "Alien-wxWidgets-0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "075m880klf66pbcfk0la2nl60vd37jljizqndrklh5y4zvzdy1nr";
    };
    propagatedBuildInputs = [
      pkgconfig perlPackages.ModulePluggable perlPackages.ModuleBuild
      gtk2 gtk3 wxGTK30
    ];
  };

  Wx = perlPackages.Wx.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [
      perlPackages.ExtUtilsXSpp
      AlienWxWidgets
    ];
  });

  WxGLCanvas = perlPackages.buildPerlPackage rec {
    name = "Wx-GLCanvas-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/${name}.tar.gz";
      sha256 = "1q4gvj4gdx4l8k4mkgiix24p9mdfy1miv7abidf0my3gy2gw5lka";
    };
    propagatedBuildInputs = [ Wx perlPackages.OpenGL libGLU ];
    doCheck = false;
  };
in
stdenv.mkDerivation rec {
  name = "slic3r-prusa-edition-${version}";
  version = "1.41.1-beta";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    gtest
    makeWrapper
  ];

  buildInputs = [
    curl
    eigen
    glew
    pcre
    perl
    tbb
    which
    Wx
    WxGLCanvas
    xorg.libXdmcp
    xorg.libpthreadstubs
  ] ++ (with perlPackages; [
    boost
    ClassXSAccessor
    EncodeLocale
    ExtUtilsMakeMaker
    ExtUtilsTypemapsDefault
    ExtUtilsXSpp
    GrowlGNTP
    ImportInto
    IOStringy
    locallib
    LWP
    MathClipper
    MathConvexHullMonotoneChain
    MathGeometryVoronoi
    MathPlanePath
    ModuleBuildWithXSpp
    Moo
    NetDBus
    OpenGL
    threads
    XMLSAX
  ]);

  # The build system uses custom logic for finding the nlopt library, which
  # doesn't work for paths in the nix store. We need to set it manually.
  NLOPT = "${nlopt}";

  prePatch = ''
    # In nix ioctls.h isn't available from the standard kernel-headers package
    # on other distributions. As the copy in glibc seems to be identical to the
    # one in the kernel, we use that one instead.
    sed -i 's|"/usr/include/asm-generic/ioctls.h"|<asm-generic/ioctls.h>|g' xs/src/libslic3r/GCodeSender.cpp

    # PERL_VENDORARCH and PERL_VENDORLIB aren't detected correctly by the build
    # system, so we have to override them
    sed -i "s|\''${PERL_VENDORARCH}|$out/lib/slic3r-prusa3d|g" xs/CMakeLists.txt
    sed -i "s|\''${PERL_VENDORLIB}|$out/lib/slic3r-prusa3d|g" xs/CMakeLists.txt
  '';

  postInstall = ''
    echo 'postInstall'
    wrapProgram "$out/bin/slic3r-prusa3d" \
    --prefix PERL5LIB : "$out/lib/slic3r-prusa3d:$PERL5LIB"

    # it seems we need to copy the icons...
    mkdir -p $out/bin/var
    cp -r ../resources/icons/* $out/bin/var/
    cp -r ../resources $out/bin/
  '';

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "Slic3r";
    sha256 = "0zn12j1cs920382ih68nnl96pw325r7slbh2183x0r3iz2h48sa6";
    rev = "version_${version}";
  };

  meta = with stdenv.lib; {
    description = "G-code generator for 3D printer";
    homepage = https://github.com/prusa3d/Slic3r;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tweber ];
  };
}
