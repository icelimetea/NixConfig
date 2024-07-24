{ pkgs, lib, nixpkgs, ... }:
{
  hardware = {
    graphics.enable = true;

    enableRedistributableFirmware = true;

    pulseaudio.enable = false;

    bluetooth = {
      enable = true;

      settings.General.Experimental = true;
    };
  };

  programs = {
    ssh = {
      startAgent = true;
      agentTimeout = "5m";
    };

    java = {
      enable = true;
      package = pkgs.jdk22;
    };

    git.enable = true;
    wireshark.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Programming languages
      python3Full
      llvmPackages_latest.llvm
      llvmPackages_latest.clang
      llvmPackages_latest.lld
      gcc_latest
      gdb
      nasm
      rustup

      # Development
      virtualenv
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.treesit-grammars.with-all-grammars ]))
      clang-tools
      jdt-language-server
      maven
      cmake
      gnumake
      jetbrains.idea-community

      # Browsers
      firefox-wayland
      chromium
      tor-browser

      # Media
      easyeffects
      obs-studio
      krita
      ffmpeg
      mpv

      # Games
      prismlauncher

      # Utilities
      alsa-utils
      smartmontools
      nvme-cli
      dmidecode
      usbutils
      pciutils
      inetutils
      ldns
      libva-utils
      openssh
      openssl
      wireguard-tools
      sbctl
      file
      fd
      ripgrep
      yt-dlp
      _7zz
      feh
      graphviz

      # Desktop apps
      thunderbird
      anki
      alacritty
      rofi-wayland
      wireshark
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
