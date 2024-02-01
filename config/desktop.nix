{ config, pkgs, nixpkgs, ... }:
let
  wallpaperPhoto = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1366x768.png";

  xkbLayout = "us,ru";
  xkbOptions = "grp:caps_toggle";

  swayConf = ''
    set $term alacritty
    set $menu "rofi -combi-modi window,run -show combi"

    exec swayidle -w \
             timeout 300  'swaylock -f -i ${wallpaperPhoto}' \
	     before-sleep 'swaylock -f -i ${wallpaperPhoto}'

    exec "easyeffects --gapplication-service"

    default_border none

    smart_gaps on
    gaps inner 20

    bindsym --no-warn $mod+d exec $menu
    bindsym --no-warn $mod+Return exec $term
    bindsym $mod+Shift+w kill

    input type:keyboard {
      xkb_layout ${xkbLayout}
      xkb_options ${xkbOptions}
    }

    input type:touchpad {
      tap enabled
      dwt disabled
    }

    bar bar-0 {
      font "Cantarell Regular 15px"

      status_command while date +'%a, %-d %b %Y, %H:%M'; do sleep 1; done

      colors background 00000070
    }

    output * bg ${wallpaperPhoto} fill #333333

    bindsym $mod+p exec "swaylock -i ${wallpaperPhoto}"
  '';

  dwmConf = ./dwm/config.h;
in {
  services = {
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

      layout = xkbLayout;
      xkbOptions = xkbOptions;

      displayManager = {
        sessionCommands = "feh --no-fehbg --bg-scale ${wallpaperPhoto} &";
        sddm = {
          enable = true;
          theme = "elarun";
        };
      };

      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.override { conf = dwmConf; };
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
    ];
  };

  environment.etc."/sway/config.d/sway.conf".text = swayConf;
}
