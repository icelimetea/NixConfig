{ pkgs, lib, nixpkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-run"
    "osu-lazer"
  ];

  hardware = {
    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;
    };

    enableRedistributableFirmware = true;
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

      askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";

      enableAskPassword = true;

      agentTimeout = "5m";
    };

    java = {
      enable = true;

      # package = pkgs.jdk18;
    };

    git.enable = true;
    wireshark.enable = true;
    npm.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Programming languages
      python3Full
      llvmPackages_latest.llvm
      llvmPackages_latest.clang
      gcc_latest
      gdb
      nasm
      nodejs
      rustup

      # Development
      virtualenv
      emacs
      jetbrains.idea-community
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

      # Games
      osu-lazer
      prismlauncher
      steam
      steam.run

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

      # Desktop apps & utilities
      bitcoin
      monero-gui
      alsa-utils
      libreoffice-fresh
      thunderbird
      file
      fd
      ripgrep
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
