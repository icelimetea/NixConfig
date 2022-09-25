{ config, pkgs, lib, ... } @ args: rec {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    file = {
      ".doom.d".source = "${pkgs.callPackage ./emacs/config.nix { inherit (programs.git) userName userEmail; }}";
      ".emacs.d".source = pkgs.fetchFromGitHub {
        owner = "doomemacs";
	repo = "doomemacs";
	rev = "731764ae7134f6ce857147f7ef067c6ce3f23abd";
	hash = "sha256-0YFYLlsPiX6DXhWEqiA2o65uYkw0XA27VJoSxAtXR2g=";
      };
    };
  };

  programs.git = {
    enable = true;
    
    userName = "icelimetea";
    userEmail = "fr3shtea@outlook.com";
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      github = {
        host = "github.com";

        identityFile = [ "${args.home.homeDirectory}/.ssh/id_github" ];
      };
      gitlab = {
        host = "gitlab.com";

        identityFile = [ "${args.home.homeDirectory}/.ssh/id_gitlab" ];
      };
    };
  };
}
