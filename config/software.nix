{ pkgs, lib, nixpkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-run"
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

      agentTimeout = "5m";
    };

    java = {
      enable = true;
      
      package = pkgs.jdk20;
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
      clang-tools
      gcc_latest
      gdb
      nasm
      rustup

      # Development
      virtualenv
      emacs
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
      sbctl

      # Desktop apps & utilities
      monero-gui
      piper
      gnome.gnome-tweaks
      alsa-utils
      libreoffice-fresh
      thunderbird
      file
      fd
      ripgrep
      yt-dlp
      zopfli
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
