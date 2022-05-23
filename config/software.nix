{ config, pkgs, nixpkgs, ... }:
let
  isIntel = true;
in {
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

  programs = {
    ssh = {
      enableAskPassword = true;
      askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";

      startAgent = true;

      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    java.enable = true;
    git.enable = true;
    wireshark.enable = true;
  };

  environment.systemPackages = with pkgs; [
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
    maven

    # Browsers
    firefox-wayland
    chromium

    # Messaging apps
    tdesktop

    # Media
    obs-studio
    gimp
    imagemagick
    ffmpeg

    # Games
    polymc

    # Firmware
    (if isIntel then microcodeIntel else microcodeAmd)

    # System administration
    ksshaskpass
    smartmontools
    dmidecode
    usbutils
    pciutils
    inetutils
    ldns
    libva-utils
    openssh
    openssl
    gnupg
    strongswan
    openvpn
    wireguard-tools

    # Desktop apps & utilities
    alsa-utils
    libreoffice-fresh
    thunderbird
    wireshark
    easyeffects
    youtube-dl
    pv
    file
    bc
    nghttp2
  ];

  environment.sessionVariables.GIT_ASKPASS = "${pkgs.ksshaskpass}/bin/ksshaskpass";
}
