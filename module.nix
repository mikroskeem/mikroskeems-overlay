{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  zfs-cfg = config.services.docker-zfs-plugin;
  scanlogd-cfg = config.services.scanlogd;
  #depot-cfg = config.services.depot;
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
        type = types.listOf types.str;
        default = [];
        description = "What datasets should be exposed to the plugin";
      };
    };

    services.scanlogd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable scanlogd service";
      };
    };

#    services.depot = {
#      enable = mkOption {
#        type = types.bool;
#        default = false;
#        description = "Whether to enable depot service";
#      };
#
#      debug = mkOption {
#        type = types.bool;
#        default = false;
#        description = "Whether to enable debug mode";
#      };
#    };
  };

  config = {
    assertions = [
      {
        assertion = zfs-cfg.enable -> (zfs-cfg.datasets != []);
        message = "Must specify atleast one dataset when Docker ZFS volume plugin is desired";
      }
    ];

    systemd.services.docker-zfs-plugin = mkIf zfs-cfg.enable {
      description = "Docker volume plugin for creating persistent volumes as a dedicated zfs dataset.";
      serviceConfig = {
        Restart = "on-abnormal";

        ExecStart = "${pkgs.docker-zfs-plugin}/bin/docker-zfs-plugin "
          + "${if (zfs-cfg.debug) then "--debug" else ""} "
          + "${concatMapStrings (x: " --dataset-name " + x) zfs-cfg.datasets}";
      };

      before = [ "docker.service" ];
      wantedBy = [ "docker.service" ];
      requires = [ "zfs.target" ];
      path = [ pkgs.zfs ];
    };

    systemd.services.scanlogd = mkIf scanlogd-cfg.enable {
      description = "A TCP port scan detection tool";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "root"; # Will drop permissions later
        Restart = "on-abnormal";
        ExecStart = "${pkgs.scanlogd}/bin/scanlogd";
        RestartSec = "10s";
        StartLimitInterval = "1min";
        Type = "forking";
      };
    };

    users.groups = optionalAttrs (scanlogd-cfg.enable) {
      scanlogd.gid = config.users.users.scanlogd.uid;
    };

    users.users = optionalAttrs (scanlogd-cfg.enable) {
      scanlogd = {
        isSystemUser = true;
        isNormalUser = false;
        group = "scanlogd";
      };
    };

#    systemd.services.depot = mkIf depot-cfg.enable {
#      descrption = "Depot is a lightweight Maven repository software";
#      wantedBy = [ "multi-user.target" ];
#
#      serviceConfig = {
#        Restart = "on-abnormal";
#
#        # TODO: generate config file
#        ExecStart = "${pkgs.depot}/bin/depot";
#      };
#    };
  };
}
