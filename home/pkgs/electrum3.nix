{ fetchFromGitHub }:
let
electrum3Fixed = nixos-17-03.callPackage electrum3 {};

nixos-17-03 = import (fetchNixPkgs {
  rev = "7f6f0c49f0e8d24346bd32c3dec20cc60108a005";
  sha256 = "1k6p0ayv5riqm4bnyxpd1aw9l34dk96qk9vngmd08lr7h8v3s285";
}) {};

electrum3 =
{ stdenv, python3, python3Packages, fetchurl }:
let
  jsonrpclib-pelix = python3Packages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "jsonrpclib-pelix";
    version = "0.3.1";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1qs95vxplxwspbrqy8bvc195s58iy43qkf75yrjfql2sim8b25sl";
    };
  };
in
stdenv.mkDerivation ((python3Packages.buildPythonApplication rec {
  name = "electrum-${version}";
  version = "3.0.2";

  src = fetchurl {
    url = "https://download.electrum.org/${version}/Electrum-${version}.tar.gz";
    sha256 = "4dff75bc5f496f03ad7acbe33f7cec301955ef592b0276f2c518e94e47284f53";
  };

  propagatedBuildInputs = with python3Packages; [
    dns
    ecdsa
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf3_2
    pyaes
    pycrypto
    pyqt5
    pysocks
    qrcode
    requests
    tlslite

    # plugins
    keepkey
    trezor

    # TODO plugins
    # amodem
    # btchip
  ];

  preBuild = ''
    sed -i 's,usr_share = .*,usr_share = "'$out'/share",g' setup.py
    pyrcc5 icons.qrc -o gui/qt/icons_rc.py
    # Recording the creation timestamps introduces indeterminism to the build
    sed -i '/Created: .*/d' gui/qt/icons_rc.py
  '';

  postInstall = ''
    # Despite setting usr_share above, these files are installed under
    # $out/nix ...
    mv $out/${python3.sitePackages}/nix/store"/"*/share $out
    rm -rf $out/${python3.sitePackages}/nix

    substituteInPlace $out/share/applications/electrum.desktop \
      --replace "Exec=electrum %u" "Exec=$out/bin/electrum %u"
  '';
}).drvAttrs // {
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electrum help >/dev/null
  '';
})
;

fetchNixPkgs = { rev, sha256 }:
  fetchFromGitHub rec {
    inherit sha256 rev;
    owner = "NixOS";
    repo = "nixpkgs-channels";
    name = "nixpkgs-${builtins.substring 0 6 rev}";
  };
in
  electrum3Fixed
