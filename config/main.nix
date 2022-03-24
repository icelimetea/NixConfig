
{ config, pkgs, nixpkgs, ... }:

let
  isIntel = true;
in rec {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot = {
    initrd.luks.devices.osroot = { device = "/dev/disk/by-uuid/6a952187-6b91-4496-92d1-aad3b941e9b7"; };

    kernelPackages = pkgs.linuxKernel.packageAliases.linux_latest;

    loader = {
      systemd-boot.enable = false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };

      grub = {
        enable = true;

        version = 2;
        efiSupport = true;

        enableCryptodisk = true;
        device = "nodev";
      };
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  hardware = {
    enableRedistributableFirmware = true;

    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;

      extraPackages = (if isIntel then [ pkgs.intel-media-driver ] else [ ]);
    };

    cpu.intel.updateMicrocode = isIntel;
    cpu.amd.updateMicrocode = !isIntel;
    
    pulseaudio.enable = false;
  };

  networking = {
    useDHCP = false;
    
    interfaces = {
      enp2s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };

    networkmanager = {
      enable = true;

      enableStrongSwan = true;

      packages = [ pkgs.networkmanager-openvpn ];
    };
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };
  
  sound.enable = true;

  services = {
    fwupd.enable = true;

    i2pd = {
      # enable = true;

      upnp.enable = true;

      proto = {
        http.enable = true;
	
	httpProxy.enable = true;
      };
    };

    tor = {
      # enable = true;

      client.enable = true;
      
      enableGeoIP = true;

      settings = {
        ExitNodes = "{ru}";
      };
    };
    
    pipewire = {
      enable = true;

      alsa.enable = true;
      pulse.enable = true;

      wireplumber.enable = true;
    };
  
    xserver = {
      enable = true;
      
      layout = "gb,ru";
      xkbOptions = "grp:caps_toggle";
      
      displayManager.sddm.enable = true;
      
      desktopManager.plasma5.enable = true;
    };
    
    printing.enable = true;
  };

  programs = {
    sway = {
      enable = true;

      extraPackages = with pkgs; [
        swaylock
	swayidle
	sway-screen-size
	rofi
	alacritty
      ];
    };

    java.enable = true;
    wireshark.enable = true;
  };

  security = {
    sudo.enable = true;
  };

  users.users = {
    lemontea = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # Programming languages
      python3Full
      clang_13
      nasm
      rustup

      # Development
      virtualenv
      emacs
      git
      jetbrains.idea-community
      maven

      # Browsers
      firefox-wayland

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

      # Desktop apps & utilities
      libreoffice-fresh
      thunderbird
      wireshark
      easyeffects
      youtube-dl
      pv
      file
      bc
      unzip
    ];

    etc = {
      "/sway/config.d/sway.conf".text = ''
        set $term alacritty

        set $wallpaper /run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1366x768.png
        set $lockWallpaper ~/.lock-wallpaper

        set $menu "rofi -combi-modi window,run -show combi"

        exec "easyeffects --gapplication-service"

        exec_always "magick $wallpaper -resize $(sway-screen-size) -blur 0x10 $lockWallpaper"

        default_border none

        smart_gaps on
        gaps inner 20

        bindsym --no-warn $mod+d exec $menu
	bindsym --no-warn $mod+Return exec $term

        input type:keyboard {
          xkb_layout ${services.xserver.layout}
          xkb_options ${services.xserver.xkbOptions}
        }

        bar bar-0 {
          font "Cantarell Regular 15px"

          status_command while date +'%a, %-d %b %Y, %H:%M'; do sleep 1; done

          colors background 00000070
        }

        output * bg $wallpaper fill #333333

        bindsym $mod+p exec "swaylock -i $lockWallpaper"
      '';
    };
  };
}
