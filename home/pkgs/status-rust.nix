{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, gperftools }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-05-11";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "975f7b8f55e65c7614c85c040f9ca506e6d434dc";
    sha256 = "1bkvdhgsjwgl77l9s1mpvrg0y5pzpc9c27kxl7fb99c5132hha5m";
  };

  cargoSha256 = "06x3y12i6djr0a121vw99avbbzws8g4bw9iazhvjpm2pj8fflxdc";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus gperftools ];

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.backuitist ];
    platforms = platforms.linux;
  };
}
