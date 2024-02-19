{ config, pkgs, lib, injected, ... }: rec {
  programs.git = {
    enable = true;
    
    userName = "icelimetea";
    userEmail = "fr3shtea@outlook.com";
  };

  home.file.".emacs".source = ./lemontea.el;

  programs.ssh = {
    enable = true;

    matchBlocks = {
      github = {
        host = "github.com";

        identityFile = [ "${injected.home.homeDirectory}/.ssh/id_github" ];
      };
      gitlab = {
        host = "gitlab.com";

        identityFile = [ "${injected.home.homeDirectory}/.ssh/id_gitlab" ];
      };
    };
  };
}
