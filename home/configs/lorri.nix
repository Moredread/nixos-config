# See https://github.com/target/lorri/issues/96#issuecomment-506890388
{ pkgs, ... }:
let
  lorri = import (fetchTarball {
    url = https://github.com/target/lorri/archive/rolling-release.tar.gz;
  }) {};
in {
  home.packages = [ lorri ];
}
