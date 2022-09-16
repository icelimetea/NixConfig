{ nixpkgs, home-manager }: rec {
  mkConfig = hostCfgs: builtins.mapAttrs
				(hostName: cfg: _mkHostConfig (cfg // { inherit hostName; }))
				hostCfgs;

  _mkHostConfig = { hostName, systemKind, users, systemModules, stateVersion }: nixpkgs.lib.nixosSystem {
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

        home-manager.users = builtins.mapAttrs
					(userName: userGroups: _mkDefaultUserCfg userName stateVersion)
					users;
      })
    ];
  };

  _mkDefaultUserCfg = userName:
  		      stateVersion:
		      { config, pkgs, ... } @ cfgArgs: let
			    			         baseCfg = {
			      			     	   home.username = userName;
			      			     	   home.homeDirectory = "/home/${userName}";

						     	   home.stateVersion = stateVersion;
						         };
						       in baseCfg // (import (../config/per-user + "/${userName}.nix") (baseCfg.home // cfgArgs));
}
