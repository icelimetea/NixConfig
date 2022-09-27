{ nixpkgs, home-manager }: rec {
  mkConfig = hostCfgs: builtins.mapAttrs
				(hostName: cfg: _mkHostConfig (cfg // { inherit hostName; }))
				hostCfgs;

  _mkHostConfig = { hostName, systemKind, users, systemModules, hmModules, stateVersion }: nixpkgs.lib.nixosSystem {
    system = systemKind;

    modules = systemModules ++ [
      home-manager.nixosModules.home-manager
      (let
        nixpkgsPath = "nixpkgs=${nixpkgs}";
      in { nixpkgs, ... }: {
        networking.hostName = hostName;

        system.stateVersion = stateVersion;

        nix.extraOptions = "experimental-features = nix-command flakes";

        nix.nixPath = [ nixpkgsPath ];

        users.users = builtins.mapAttrs
                                (userName: userGroups: {
                                  isNormalUser = true;
                                  extraGroups = userGroups;
                                })
                                users;

        home-manager.useGlobalPkgs = true;

        home-manager.sharedModules = hmModules;

        home-manager.users = builtins.mapAttrs
                                        (userName: userGroups: _mkDefaultUserCfg userName stateVersion)
                                        users;
      })
    ];
  };

  _mkDefaultUserCfg = username:
                      stateVersion: { config, pkgs, lib, ... } @ cfgArgs:
                      let
                        baseCfg.home = {
                          inherit username stateVersion;

                          homeDirectory = "/home/${username}";
                        };
                        definedCfg = import (../config/per-user + "/${username}.nix") (nixpkgs.lib.attrsets.recursiveUpdate baseCfg.home cfgArgs);
                      in nixpkgs.lib.attrsets.recursiveUpdate baseCfg definedCfg;
}
