{ home-manager }: rec {
  mkConfig = hostCfgs: builtins.mapAttrs
				(hostName: cfg: _mkHostConfig (cfg // { inherit hostName; }))
				hostCfgs;

  _mkHostConfig = { hostName, systemKind, users, systemModules }: nixpkgs.lib.nixosSystem {
    system = systemKind;

    modules = systemModules ++ [
      home-manager.nixosModules.home-manager
      ({ nixpkgs, ... }: {
	networking.hostName = hostName;

        system.stateVersion = "22.05";

        nix.extraOptions = "experimental-features = nix-command flakes";

        nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

        users.users = builtins.mapAttrs
				(userName: userGroups: {
				 	  isNormalUser = true;
					  extraGroups = userGroups;
				})
				users;

        home-manager.useGlobalPkgs = true;

        home-manager.users = builtins.foldl'
					(x: y: x // y)
					{}
					(map
						(userName: { "${userName}" = import (./config/per-user + "/${userName}.nix"); })
					  	(builtins.attrNames users)
					);
      })
    ];
  };
}
