{ config, pkgs, lib, homeDirectory, ... }: rec {
  programs.git = {
    enable = true;
    
    userName = "icelimetea";
    userEmail = "fr3shtea@outlook.com";
  };

  programs.doomemacs = {
    enable = true;

    inherit (programs.git) userName userEmail;
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      github = {
        host = "github.com";

        identityFile = [ "${homeDirectory}/.ssh/id_github" ];
      };
      gitlab = {
        host = "gitlab.com";

        identityFile = [ "${homeDirectory}/.ssh/id_gitlab" ];
      };
    };
  };
}
