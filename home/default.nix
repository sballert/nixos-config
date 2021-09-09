{ pkgs, nixpkgs, wallpaper, pathToConfig, readConfig, lib, ... }: {

  inherit nixpkgs;

################################################################################
  home = {
    stateVersion = "21.05";
    packages = with pkgs; [
      aria2
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
      google-chrome
      gnupg
      htop
      jq
      ldns
      libreoffice
      libxml2
      mpv
      niv
      nix-prefetch-github
      nix-util
      nix-linter
      onlykey
      onlykey-agent
      onlykey-cli
      openvpn
      p7zip
      pass
      pulseaudio-ctl
      python3
      python3Packages.yamllint
      pwgen
      session-menu
      shellcheck
      slack
      spaceship-prompt
      spotify
      st
      teams
      texlive.combined.scheme-full
      toggle-screen-locker
      toggle-touchpad
      traceroute
      tree
      udiskie
      unzip
      unar
      veracrypt
      wget
      xlogout
      xmobar
      xorg.xprop
      xrandr-util
      youtube-dl-light
      zip
    ];

    keyboard = {
      layout = "us";
      options = ["compose:ralt" "compose:rwin" "ctrl:nocaps"];
    };

    file = {
      ".config/xmobar/xmobarrc".text = readConfig "xmobarrc";
      ".emacs.d/init.el".text = readConfig "init.el";
      ".ghci".text = readConfig "ghci";
      ".guile".text = readConfig "guile";
      ".gnupg/sshcontrol".text = ''
        447910F828DF001601E7FAECF768DFA93DF87136
      '';
    };
    sessionVariables = {
      EMAIL="sballert@posteo.de";
      _JAVA_AWT_WM_NONREPARENTING="1";
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
  programs = import ./programs { inherit pkgs readConfig lib; };
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
