{ nixpkgs, home-manager }:
let
  configDir = ../config;

  mkHostConfig = { hostName, systemKind, users, systemModules, stateVersion }: nixpkgs.lib.nixosSystem {
    system = systemKind;

    modules = systemModules ++ [
      home-manager.nixosModules.home-manager
      ({
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
                                        (userName: userGroups: mkDefaultUserCfg userName stateVersion)
                                        users;
      })
      (configDir + "/per-machine/${hostName}.nix")
    ];
  };

  mkDefaultUserCfg = username:
                      stateVersion: { config, pkgs, lib, ... } @ cfgArgs:
                      let
                        baseCfg = {
                          home = {
                            inherit username stateVersion;

                            homeDirectory = "/home/${username}";
                          };
                        };
                        definedCfg = import (configDir + "/per-user/${username}.nix") (nixpkgs.lib.attrsets.recursiveUpdate ({ injected = baseCfg; }) cfgArgs);
                      in nixpkgs.lib.attrsets.recursiveUpdate baseCfg definedCfg;

in {
  mkConfig = systemModules: hostCfgs:
    builtins.mapAttrs
      (hostName: cfg: mkHostConfig (cfg // { inherit hostName systemModules; }))
      hostCfgs;
}
