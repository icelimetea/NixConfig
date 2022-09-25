{ config, pkgs, lib, ... } @ args: rec {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    home.activation.configureEmacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ ! -a $HOME/.emacs.d/.doomrc ]]; then
         until ping -c 1 'github.com' >/dev/null 2>&1; do :; done

         rm -r $HOME/.emacs.d

         git clone 'https://github.com/doomemacs/doomemacs.git' $HOME/.emacs.d

         $HOME/.emacs.d/bin/doom install --force
      fi
    '';

    file.".doom.d".source = "${pkgs.callPackage ./emacs/config.nix { inherit (programs.git) userName userEmail; }}";
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
