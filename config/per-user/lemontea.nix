{ config, pkgs, lib, ... } @ args:
let
  doomEmacsCfg = import ./emacs/config.nix;
in (rec {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    file.".doom.d".source = "${pkgs.callPackage doomEmacsCfg { inherit (programs.git) userName userEmail; }}";
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
})
