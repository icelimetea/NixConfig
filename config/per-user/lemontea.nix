{ config, pkgs, lib, injected, ... }: rec {
  programs.git = {
    enable = true;
    
    userName = "icelimetea";
    userEmail = "fr3shtea@outlook.com";
  };

  programs.doomemacs = {
    enable = true;

    modules = {
      completion = [
        "company"
        "vertico"
      ];

      ui = [
        "doom"
        "doom-dashboard"
        "hl-todo"
        "modeline"
        "ophints"
        "popup +defaults"
        "tabs"
        "treemacs"
        "vc-gutter +pretty"
        "vi-tilde-fringe"
        "workspaces"
      ];

      editor = [
        "evil +everywhere"
        "file-templates"
        "fold"
        "snippets"
      ];

      emacs = [
        "dired"
        "electric"
        "undo"
        "vc"
      ];

      checkers = [ "syntax" ];

      tools = [
        "lookup"
        "lsp"
        "magit"
      ];

      lang = [
        "cc +lsp"
        "csharp"
        "data"
        "emacs-lisp"
        "go +lsp"
        "json"
        "java +lsp"
        "javascript"
        "kotlin"
        "latex"
        "lua"
        "markdown"
        "nix"
        "python"
        "rust +lsp"
        "sh"
        "yaml"
      ];

      config = [ "default +bindings +smartparens" ];
    };

    inherit (programs.git) userName userEmail;
  };

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
