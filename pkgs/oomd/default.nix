{ pkgs ? import <nixpkgs> { }
, stdenv ? pkgs.stdenv
, lib ? stdenv.lib
}:

with lib;
stdenv.mkDerivation {
  name = "oomd";
  version = "0.3.2";

  src = builtins.fetchurl {
    url = "https://github.com/facebookincubator/oomd/archive/v0.3.2.tar.gz";
    sha256 = "1grb4h56vzy39ahwc2s9mw1lvycidzrn2fq6ab7d8k4rl0gvr3vf";
  };

  nativeBuildInputs = with pkgs; [ meson pkg-config cmake ninja jsoncpp systemd ] ++ [ gtest gmock ];
  patches = [ ./no-systemd-or-config-file.patch ];
  mesonFlags = [ "-Dsysconfdir=/etc" ];
}

# vim:sts=2:sw=2:et
