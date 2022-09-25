{ config, pkgs, lib, ... } @ args:
let
  emacsCfg = { userName, userEmail, stdenv, ... }: stdenv.mkDerivation (rec {
    name = "emacs-cfg";

    src = ./emacs;

    dontBuild = true;

    installPhase = ''
    runHook preInstall

    cp -r ${src} $out

    tee $out/config.el <<EOF
    (setq user-full-name "${userName}"
	      user-mail-address "${userEmail}"
	      doom-theme 'doom-one
	      display-line-numbers-type t
	      org-directory "~/org/")
    EOF
    
    runHook postInstall
    '';
  });
in (rec {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    file.".doom.d".source = "${pkgs.callPackage emacsCfg { inherit (programs.git) userName userEmail; }}";
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
