{ stdenv, fetchFromGitHub, pkgs, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gitwatch-${meta.version}";

  src = fetchFromGitHub {
    owner = "gitwatch";
    repo = "gitwatch";
    rev = "a0db552aedb5d597448ef7944cdb49cc359beeb6";
    sha256 = "15sga4wfmaj6084yx4hfwp48xaw03pv4d1bdc4qk0chd2m994rp7";
  };

  buildInputs = with pkgs; [ inotifyTools git ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp gitwatch.sh $out/bin/gitwatch
    chmod a+x $out/bin/gitwatch
    wrapProgram $out/bin/gitwatch --prefix PATH : ${stdenv.lib.makeBinPath buildInputs}
  '';

  meta = {
    version = "0.1.0";
    description = "Gitwatch";
  };
}
