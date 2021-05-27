{ config
, pkgs
, lib
, ...
}:

with lib;
let
  scanlogd-cfg = config.services.scanlogd;
  #depot-cfg = config.services.depot;
in
{
  options = {
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
