{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  zfs-cfg = config.services.docker-zfs-plugin;
in
{
  options = {
    services.docker-zfs-plugin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable docker-zfs-plugin service";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable debug mode";
      };

      datasets = mkOption {
        type = types.listOf types.string;
        default = [];
        description = "What datasets should be exposed to the plugin";
      };
    };
  };

  config = {
    systemd.services.docker-zfs-plugin = mkIf zfs-cfg.enable {
      description = "Docker volume plugin for creating persistent volumes as a dedicated zfs dataset.";
      restart = "always";

      before = [ "docker.service" ];
#      after = ["zfs-mount.service", "zfs-import-cache.service"];
#      requires = [ "zfs-import-cache.service" ];
      wantedBy = [ "docker.service" ];

      start = "${pkgs.docker-zfs-plugin}/bin/docker-zfs-plugin";
    };

    systemd.services.depot = mkIf depot.enable {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable docker-zfs-plugin service";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable debug mode";
      };

    };
  }
}
