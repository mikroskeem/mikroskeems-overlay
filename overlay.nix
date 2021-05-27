self: super:

#let
#  callPackage = super.lib.callPackageWith super;
#in
with super;
{
  depot = callPackage ./pkgs/depot { };
  scanlogd = callPackage ./pkgs/scanlogd { };
}
