{ pkgs, lib, nixpkgs, ... }:
let
  isIntel = true;
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  hardware = {
    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;

      extraPackages = (if isIntel then [ pkgs.intel-media-driver ] else [ ]);
    };

    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = isIntel;
    cpu.amd.updateMicrocode = !isIntel;
  };

  virtualisation.libvirtd = {
    enable = false;

    qemu = {
      package = pkgs.qemu_kvm;

      ovmf.enable = true;
      swtpm.enable = true;
    };
  };

  programs = {
    ssh = {
      startAgent = true;

      askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";

      enableAskPassword = true;

      agentTimeout = "5m";
    };

    gnupg.agent = {
      enable = true;

      pinentryFlavor = "qt";
    };

    java.enable = true;
    git.enable = true;
    wireshark.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Programming languages
      python3Full
      llvmPackages_latest.llvm
      llvmPackages_latest.clang
      gcc_latest
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

      # Games
      polymc
      steam

      # Firmware
      (if isIntel then microcodeIntel else microcodeAmd)

      # System administration
      virt-manager
      smartmontools
      dmidecode
      usbutils
      pciutils
      inetutils
      ldns
      libva-utils
      openssh
      openssl
      strongswan
      openvpn
      wireguard-tools

      # Desktop apps & utilities
      alsa-utils
      libreoffice-fresh
      thunderbird
      file
      bc
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
