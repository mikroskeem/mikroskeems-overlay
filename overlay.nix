self: super:

#let
#  callPackage = super.lib.callPackageWith super;
#in
with super;
{
  depot = callPackage ./pkgs/depot {};
  docker-zfs-plugin = callPackage ./pkgs/docker-zfs-plugin {};
  scanlogd = callPackage ./pkgs/scanlogd {};
}
