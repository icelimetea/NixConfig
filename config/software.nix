{ pkgs, lib, nixpkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
    "nvidia-x11"
    "nvidia-settings"
  ];

  hardware = {
    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;
    };

    enableRedistributableFirmware = true;

    pulseaudio.enable = false;

    bluetooth = {
      enable = true;

      settings.General.Experimental = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;

        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
  };

  programs = {
    ssh = {
      startAgent = true;
      agentTimeout = "5m";
    };

    java = {
      enable = true;
      package = pkgs.jdk21;
    };

    npm.enable = true;
    git.enable = true;
    wireshark.enable = true;
    steam.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Programming languages
      python3Full
      llvmPackages_latest.llvm
      llvmPackages_latest.clang
      llvmPackages_latest.lld
      clang-tools
      gcc_latest
      nodePackages_latest.nodejs
      gdb
      nasm
      rustup

      # Development
      virtualenv
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.treesit-grammars.with-all-grammars ]))
      jetbrains.idea-community
      jetbrains.pycharm-community
      maven

      # Browsers
      firefox-wayland
      chromium

      # Messaging apps
      tdesktop

      # Media
      easyeffects
      obs-studio
      gimp
      imagemagick
      ffmpeg
      mpv

      # Games
      prismlauncher

      # System administration
      virt-manager
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
      wireshark
      wireguard-tools
      sbctl

      # Desktop apps & utilities
      monero-gui
      alsa-utils
      libreoffice-fresh
      thunderbird
      file
      fd
      ripgrep
      yt-dlp
      zopfli
      _7zz
      anki
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
