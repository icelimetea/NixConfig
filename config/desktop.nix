{ config, pkgs, nixpkgs, ... }:
let
  xkbLayout = "us,ru";
  xkbOptions = "grp:caps_toggle";

  swayConf = ''
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
      xkb_layout ${xkbLayout}
      xkb_options ${xkbOptions}
    }

    bar bar-0 {
      font "Cantarell Regular 15px"

      status_command while date +'%a, %-d %b %Y, %H:%M'; do sleep 1; done

      colors background 00000070
    }

    output * bg $wallpaper fill #333333

    bindsym $mod+p exec "swaylock -i $wallpaper"
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

      displayManager.sddm = {
        enable = true;
	theme = "elarun";
      };

      windowManager.dwm = {
        enable = true;
	package = dwm.override { conf = dwmConf; };
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

  environment.etc."/sway/config.d/sway.conf".text = swayConf;
}
