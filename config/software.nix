{ pkgs, lib, nixpkgs, ... }:
let
  isIntel = true;
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "cloudflare-warp"
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

      # Games
      polymc
      steam
      steam.run

      # Firmware
      (if isIntel then microcodeIntel else microcodeAmd)

      # System administration
      virt-manager
      smartmontools
      nvme-cli
      dmidecode
      usbutils
      pciutils
      inetutils
      wireshark
      ldns
      libva-utils
      openssh
      openssl
      strongswan
      openvpn
      wireguard-tools

      # Desktop apps & utilities
      monero-gui
      alsa-utils
      libreoffice-fresh
      thunderbird
      file
      bc
      cloudflare-warp
    ];

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  };
}
