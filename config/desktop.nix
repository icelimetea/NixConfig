{ config, pkgs, nixpkgs, ... }:
let
  wallpaperPhoto = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1366x768.png";

  xkbProps = {
    layout = "us,ru";
    options = "grp:caps_toggle";
  };

  swayConf = ''
    set $mod Mod4

    set $left h
    set $down j
    set $up k
    set $right l

    set $term alacritty
    set $menu "rofi -combi-modi window,run,drun -show combi"

    exec swayidle -w \
             timeout 300  'swaylock -f -i ${wallpaperPhoto}' \
             before-sleep 'swaylock -f -i ${wallpaperPhoto}'

    exec "easyeffects --gapplication-service"

    default_border none

    smart_gaps on
    gaps inner 20

    bindsym $mod+d            exec $menu
    bindsym $mod+Return       exec $term
    bindsym $mod+Shift+w      kill
    bindsym $mod+Shift+c      reload
    bindsym $mod+Shift+e      exit
    bindsym $mod+$left        focus left
    bindsym $mod+$down        focus down
    bindsym $mod+$up          focus up
    bindsym $mod+$right       focus right
    bindsym $mod+Shift+$left  move left
    bindsym $mod+Shift+$down  move down
    bindsym $mod+Shift+$up    move up
    bindsym $mod+Shift+$right move right
    bindsym $mod+1            workspace number 1
    bindsym $mod+2            workspace number 2
    bindsym $mod+3            workspace number 3
    bindsym $mod+4            workspace number 4
    bindsym $mod+5            workspace number 5
    bindsym $mod+6            workspace number 6
    bindsym $mod+7            workspace number 7
    bindsym $mod+8            workspace number 8
    bindsym $mod+9            workspace number 9
    bindsym $mod+0            workspace number 10
    bindsym $mod+Shift+1      move container to workspace number 1
    bindsym $mod+Shift+2      move container to workspace number 2
    bindsym $mod+Shift+3      move container to workspace number 3
    bindsym $mod+Shift+4      move container to workspace number 4
    bindsym $mod+Shift+5      move container to workspace number 5
    bindsym $mod+Shift+6      move container to workspace number 6
    bindsym $mod+Shift+7      move container to workspace number 7
    bindsym $mod+Shift+8      move container to workspace number 8
    bindsym $mod+Shift+9      move container to workspace number 9
    bindsym $mod+Shift+0      move container to workspace number 10
    bindsym $mod+s            layout stacking
    bindsym $mod+w            layout tabbed
    bindsym $mod+e            layout toggle split
    bindsym $mod+f            fullscreen
    bindsym $mod+r            mode "resize"
    bindsym $mod+p            exec "swaylock -i ${wallpaperPhoto}"

    mode "resize" {
      bindsym $left  resize shrink width 10px
      bindsym $down  resize grow height 10px
      bindsym $up    resize shrink height 10px
      bindsym $right resize grow width 10px

      bindsym Return mode "default"
      bindsym Escape mode "default"
    }

    input type:keyboard {
      xkb_layout ${xkbProps.layout}
      xkb_options ${xkbProps.options}
    }

    input type:touchpad {
      tap enabled
      dwt disabled
    }

    bar {
      position top

      font "Cantarell Regular 15px"

      status_command while date +'%a, %-d %b %Y, %H:%M'; do sleep 1; done

      colors {
        statusline #ffffff
        background #00000070
      }
    }

    output * bg ${wallpaperPhoto} fill #333333
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

      xkb = xkbProps;

      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.override { conf = dwmConf; };
      };
    };

    displayManager = {
      sessionCommands = "feh --no-fehbg --bg-scale ${wallpaperPhoto} &";
      sddm.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };

  programs.sway = {
    enable = true;

    extraOptions = [ "--unsupported-gpu" ];

    extraPackages = with pkgs; [
      swaylock
      swayidle
    ];
  };

  environment.etc."sway/config".text = swayConf;
}
