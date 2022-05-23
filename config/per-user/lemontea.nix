{ config, pkgs, ... } : rec {
  home.username = "lemontea";
  home.homeDirectory = "/home/${home.username}";

  home.stateVersion = "22.05";

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

        identityFile = [ "${home.homeDirectory}/.ssh/id_github" ];
      };
      gitlab = {
        host = "gitlab.com";

        identityFile = [ "${home.homeDirectory}/.ssh/id_gitlab" ];
      };
    };
  };
}