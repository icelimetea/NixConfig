{ config, pkgs, lib, home, ... } @ args: (rec {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    activation.configureEmacs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      $DRY_RUN_CMD git clone 'https://github.com/doomemacs/doomemacs.git' $HOME/.emacs.d

      $DRY_RUN_CMD $HOME/.emacs.d/bin/doom sync
    '';

    file = {
      ".doom.d" = {
        source = ./emacs;
	recursive = true;
      };

      ".doom.d/config.el".text = ''
        (setq user-full-name "${programs.git.userName}"
	      user-mail-address "${programs.git.userEmail}"
	      doom-theme 'doom-one
	      display-line-numbers-type t
	      org-directory "~/org/")
      '';
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
})
