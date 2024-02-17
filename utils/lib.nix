{ nixpkgs, home-manager }:
let
  configDir = ../config;

  mkHostConfig = { hostName, systemKind, users, systemModules, stateVersion }: nixpkgs.lib.nixosSystem {
    system = systemKind;

    modules = systemModules ++ [
      home-manager.nixosModules.home-manager
      ({ config, ... }: {
        networking.hostName = hostName;

        system.stateVersion = stateVersion;

        nix = {
          extraOptions = "experimental-features = nix-command flakes";

          nixPath = [ "nixpkgs=${nixpkgs}" ];
        };

        users.users = builtins.mapAttrs
                                (userName: userGroups: {
                                  isNormalUser = true;
                                  extraGroups = userGroups;
                                })
                                users;

        home-manager.users = builtins.mapAttrs
                                        (userName: userGroups: mkDefaultUserCfg config userName stateVersion)
                                        users;
      })
      (configDir + "/per-machine/${hostName}.nix")
    ];
  };

  mkDefaultUserCfg = systemConfig:
                     username:
                     stateVersion:
		     cfgArgs:
                     let
                       baseCfg = {
                         home = {
                           inherit username stateVersion;

                           homeDirectory = systemConfig.users.users.${username}.home;
                         };
                       };
                       definedCfg = import (configDir + "/per-user/${username}.nix") (cfgArgs // { injected = baseCfg; });
                     in nixpkgs.lib.attrsets.recursiveUpdate baseCfg definedCfg;
in {
  mkConfig = { systemModules, hosts, users }:
    builtins.mapAttrs
      (hostName: cfg: mkHostConfig (cfg // { inherit hostName systemModules users; }))
      hosts;
}
