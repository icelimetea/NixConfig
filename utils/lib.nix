{ nixpkgs, home-manager }:
let
  mkHostConfig = { hostName, stateVersion, systemKind, systemConfig, systemModules, users }: nixpkgs.lib.nixosSystem {
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
                                (userName: userConfig: {
                                  isNormalUser = true;
                                  extraGroups = userConfig.groups;
                                })
                                users;

        home-manager.users = builtins.mapAttrs
                                        (userName: userConfig: mkDefaultUserCfg config userName userConfig.config stateVersion)
                                        users;
      })
      systemConfig
    ];
  };

  mkDefaultUserCfg = systemConfig:
                     username:
                     userConfig:
                     stateVersion:
                     { pkgs, ... } @ cfgArgs:
                     let
                       baseCfg = {
                         home = {
                           inherit username stateVersion;

                           homeDirectory = systemConfig.users.users.${username}.home;
                         };
                       };
                       definedCfg = import userConfig (cfgArgs // { injected = baseCfg; });
                     in nixpkgs.lib.attrsets.recursiveUpdate baseCfg definedCfg;
in {
  mkConfig = { systemModules, hosts, users }:
    builtins.mapAttrs
      (hostName: cfg: mkHostConfig (cfg // { inherit hostName systemModules users; }))
      hosts;
}
