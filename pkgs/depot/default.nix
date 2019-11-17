{
  pkgs ? (import <nixpkgs> {}).pkgs,
  goPath ? "go_1_12"
}:
  with pkgs;
  let
    go = lib.getAttrFromPath (lib.splitString "." goPath) pkgs;
    buildGoPackage = pkgs.buildGoPackage.override { inherit go; };
  in
    buildGoPackage {
      name = "depot";
      version = "0.0.1";
      goPackagePath = "github.com/mikroskeem/depot";
      src = fetchFromGitHub {
        owner = "mikroskeem";
        repo = "depot";
        rev = "46d3ae250f1de4f019730888a8c679716c8274f4";
        sha256 = "0jj7s1rmmb3142nbf6cfgag5hw16bd5mxrfgrr2pxx9msq0a5zy9";
      };
      goDeps = ./deps.nix;
    }
