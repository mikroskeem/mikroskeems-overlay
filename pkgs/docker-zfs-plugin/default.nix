{
  pkgs ? (import <nixpkgs> {}).pkgs,
  stdenv ? (pkgs.stdenv),
  buildGoPackage ? (pkgs.buildGoPackage),
  fetchFromGitHub ? (pkgs.fetchFromGitHub),
}:

buildGoPackage rec {
  name = "docker-zfs-plugin-${version}";
  version = "1.0.3";

  goPackagePath = "github.com/mikroskeem/docker-zfs-plugin";
  src = fetchFromGitHub {
    owner = "mikroskeem";
    repo = "docker-zfs-plugin";
    rev = "3c0e3ee66a467b61f2a856878925c5fade131f69";
    sha256 = "1ps9mqizcsa624x0k0bc32isk14gq5czmk1445qamccf7bxjd980";
  };

  buildInputs = [ pkgs.zfs ];
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Docker volume plugin for creating persistent volumes as a dedicated zfs dataset.";
    longDescription = ''
      docker-zfs-plugin is a plugin for Docker for creating persistent volumes as a dedicated zfs dataset
    '';
    homepage = "https://github.com/mikroskeem/docker-zfs-plugin";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
