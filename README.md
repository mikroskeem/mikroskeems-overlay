# mikroskeem's overlay

This is my first Nix overlay

## Why?

I made this mainly because I needed few packages for NixOS in production, and to try make sense of Nix's documentation (which is kinda lacking about overlays honestly)

## Installation

It's not so hard, trust me. _I thought it needs some other weird tricks._

_Honestly I'm still not completely sure about this..._

### Locally (user overlays)

Symlink `overlay.nix` from repo to `~/.config/nixpkgs/overlays/mikroskeems-overlay.nix`

### Globally (system wide)

You can provide a path to cloned repository (e.g `/home/me/mikroskeems-overlay`) inside `/etc/nixos/configuration.nix`,
or add the following:

```nix
{
  imports = [
    ./hardware-configuration.nix
    # Other imports you might have here...
    # ...
    (fetchTarball {
      url = "https://github.com/mikroskeem/mikroskeems-overlay/archive/<the commit hash>.tar.gz";
      sha256 = "<output of 'nix-prefetch-url --unpack (url above)'>";
    })
  ];
  # ...
}
```

Though there are more ways for that (e.g use let/in), but you'll very likely learn about them later.
