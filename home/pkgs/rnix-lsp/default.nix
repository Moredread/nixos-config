{ stdenv, rustNightlyPlatform, fetchFromGitHub }:

rustNightlyPlatform.buildRustPackage rec {
  name = "rnix-lsp-${version}";
  version = "2019-10-01";

  cargoSha256 = "0j9swbh9iig9mimsy8kskzxqpwppp7jikd4cz2lz16jg7irvjq0w";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "3e6b015bb1fa2b1349519f56fbe0f4897a98ca69";
    sha256 = "01s1sywlv133xzakrp2mki1w14rkicsf0h0wbrn2nf2fna3vk5ln";
  };

  meta = with stdenv.lib; {
    description = "Language Server for Nix";
    homepage = https://github.com/nix-community/rnix-lsp;
    license = licenses.mit;
  };
}
