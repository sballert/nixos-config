{ pkgs, nixpkgs, wallpaper, pathToConfig, readConfig, ... }: {

  inherit nixpkgs;

################################################################################
  home = {
    packages = with pkgs; [
      backup
      bat
      bluetoothctl-menu
      brightnessctl
      docker-compose
      exa
      fd
      gimp
      gitAndTools.gitflow
      gnome3.dconf
      gnupg
      libreoffice
      nix-util
      pass
      pulseaudio-ctl
      session-menu
      slack
      spotify
      st
      toggle-touchpad
      udiskie
      vagrant
      xlogout
      xmobar
      xorg.xprop
      xrandr-util
      youtube-dl-light
    ];
    file = {
      ".config/xmobar/xmobarrc".text = readConfig "xmobarrc";
      ".emacs.d/init.el".text = readConfig "init.el";
      ".ghci".text = readConfig "ghci";
      ".gnupg/sshcontrol".text = ''
        447910F828DF001601E7FAECF768DFA93DF87136
      '';
    };
  };
################################################################################
  services = import ./services;
################################################################################
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pathToConfig "xmonad.hs";
    };
    initExtra = ''
      feh --bg-scale ${wallpaper} &
      ${pkgs.xrandr-util}/bin/xrandr-util primary
      ${pkgs.xorg.xset}/bin/xset -dpms
      ${pkgs.xorg.xset}/bin/xset s off
    '';
  };
################################################################################
  gtk = {
    enable = true;
    font.name = "Noto Sans Display 10";
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
  };
################################################################################
  programs = import ./programs { inherit pkgs; };
################################################################################
  systemd.user.services = {
    autorepeat = {
      Unit = {
        Description = "Keyboard autorepeat rate";
        PartOf = [ "hm-graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.xorg.xset}/bin/xset r rate 200 60";
      };
      Install = {
        WantedBy = [ "hm-graphical-session.target" ];
      };
    };
  };
################################################################################
}
