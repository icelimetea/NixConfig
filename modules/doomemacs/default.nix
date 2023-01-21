{ config, pkgs, lib, ... }:
let
  cfg = config.programs.doomemacs;
in {
  options.programs.doomemacs = {
    enable = lib.mkEnableOption "Doom Emacs";

    userName = lib.mkOption {
      type = lib.types.str;
      description = "Username used to identify you in GPG, Git, etc...";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "Email used to identify you in GPG, Git, etc...";
    };

    modules = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      description = "Doom Emacs modules to enable.";
    };
  };

  config.home = lib.mkIf cfg.enable {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    activation.configureEmacs = lib.hm.dag.entryAfter [ "writeBoundary" ] "sh ${./sync-doom.sh}";

    file.".doom.d".source = "${pkgs.callPackage ./config.nix { inherit (cfg) userName userEmail modules; }}";
  };
}
