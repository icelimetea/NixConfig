{ config, pkgs, homeDirectory, ... } @ args: {
  importantField = builtins.trace args;

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

        identityFile = [ "${homeDirectory}/.ssh/id_github" ];
      };
      gitlab = {
        host = "gitlab.com";

        identityFile = [ "${homeDirectory}/.ssh/id_gitlab" ];
      };
    };
  };
}
