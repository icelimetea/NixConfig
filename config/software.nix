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
      gcc_latest
      gdb
      nasm
      rustup
      luajit

      # Development
      virtualenv
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.treesit-grammars.with-all-grammars ]))
      clang-tools
      jdt-language-server
      maven
      cmake
      gnumake
      jetbrains.idea-community
      eclipses.eclipse-java

      # Browsers
      firefox-wayland
      chromium

      # Media
      easyeffects
      obs-studio
      gimp
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
      zopfli
      _7zz
      feh

      # Desktop apps
      virt-manager
      libreoffice-fresh
      thunderbird
      anki
      alacritty
      rofi-wayland
      wireshark
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
