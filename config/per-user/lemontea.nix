{ config, pkgs, lib, stdenv, ... } @ args:
let
  emacsCfg = userName: userEmail: stdenv.mkDerivation {
    name = "emacs-cfg";

    src = ./emacs;

    dontBuild = true;

    installPhase = ''
    runHook preInstall

    cp -r ${src} $out

    tee $out/config.el <<<EOF
    (setq user-full-name "${userName}"
	      user-mail-address "${userEmail}"
	      doom-theme 'doom-one
	      display-line-numbers-type t
	      org-directory "~/org/")
    EOF
    
    runHook postInstall
    '';
  };
in (rec {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    home.file.".doom.d".source = emacsCfg programs.git.userName
    			       	 	  programs.git.userEmail;
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
