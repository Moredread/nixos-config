{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, gperftools, gnused, gnugrep, gawk, iw }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-07-20";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "ad5a44feabc93a50ad979a97ee78c17977e9fa2e";
    sha256 = "10982sy2fsk588jdqxpywpqx9jjhy8lyns3qrfjjrx6w3yfvk03c";
  };

  cargoSha256 = "0b7ayrxhsh1hm78ydykblmjjznprxf0bqsfw2g2ryyzqw0cvrmw5";

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
