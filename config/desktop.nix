{ config, pkgs, nixpkgs, ... }: rec {
  hardware = {
    pulseaudio.enable = false;

    bluetooth = {
      enable = true;

      settings.General.Experimental = true;
    };
  };

  services = {
    # postgresql = {
    #   enable = true;
    # 
    #   settings.password_encryption = "scram-sha-256";
    #   authentication = "host all lemontea localhost scram-sha-256";
    # };

    # rabbitmq.enable = true;

    upower.enable = true;
    geoclue2.enable = true;

    pipewire = {
      enable = true;

      alsa.enable = true;
      pulse.enable = true;

      wireplumber.enable = true;
    };

    xserver = {
      enable = true;

      layout = "us,ru";
      xkbOptions = "grp:caps_toggle";

      displayManager.sddm = {
        enable = true;
	theme = "maya";
      };

      windowManager.dwm = {
        enable = true;
      };
    };
  };

  programs.sway = {
    enable = true;

    extraOptions = [ "--unsupported-gpu" ];

    extraPackages = with pkgs; [
      swaylock
      swayidle
      sway-screen-size
      rofi-wayland
      alacritty
    ];
  };

  environment.etc."/sway/config.d/sway.conf".text = ''
    set $term alacritty
    set $menu "rofi -combi-modi window,run -show combi"

    set $wallpaper /run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1366x768.png

    exec "easyeffects --gapplication-service"

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

    bindsym $mod+p exec "swaylock -i $wallpaper"
  '';
}
