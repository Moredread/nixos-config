{ stdenv, rustPlatform, fetchFromGitLab }:

rustPlatform.buildRustPackage rec {
  name = "nix-lsp-${version}";
  version = "2019-04-06";

  cargoSha256 = "08zx7jmlnq27ksw3l7ww6qbmgli8fwv96fy5ymdgzw2bly951hnd";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "nix-lsp";
    rev = "6fac185abca203b870549264a97476cc148c7308";
    sha256 = "1qgm2q11mk43qvxz76qz599k4vn1p7wzkpb74d1dpw6cjrmnh4hf";
  };

  meta = with stdenv.lib; {
    description = "Language Server for Nix";
    homepage = https://gitlab.com/jD91mZM2/nix-lsp;
    license = licenses.mit;
  };
}
