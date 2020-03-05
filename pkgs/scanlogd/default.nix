{ pkgs ? (import <nixpkgs> {}).pkgs
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
}:

let
  pname = "scanlogd";
  version = "2.2.7";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.openwall.com/scanlogd/${pname}-${version}.tar.gz";
    sha256 = "1nkihzpxhxbpwbmmfr9czl1pjwbqylhgv3ffsabaf7jnnf11qsjm";
  };

  NIX_CFLAGS_COMPILE = "-Wno-cpp";
  outputs = [ "out" "chroot" ];

  patches = [
    ./fix-chdir-warning.patch
  ];

  configurePhase = ''
    #sed -i '/^#define SCANLOGD_CHROOT/s/.*/#undef SCANLOGD_CHROOT/' params.h
    sed -i '/^#define SCANLOGD_CHROOT/s#".\+"#"'"$chroot"'"#' params.h
  '';

  buildPhase = ''
    make linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $chroot
    cp scanlogd $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A port scan detection tool";
    #license = licenses.;
    platforms = stdenv.lib.platforms.unix;
  };
}
