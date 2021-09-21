{ pkgs, nixpkgs, wallpaper, pathToConfig, readConfig, lib, ... }: {

  inherit nixpkgs;

################################################################################
  home = {
    stateVersion = "21.11";
    packages = with pkgs; [
      my.backup
      my.bluetoothctl-menu
      my.nix-util
      my.session-menu
      my.toggle-screen-locker
      my.toggle-touchpad
      my.xlogout
      my.xrandr-util
      aria2
      bat
      brightnessctl
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
      shellcheck
      spaceship-prompt
      spotify
      st
      texlive.combined.scheme-full
      traceroute
      tree
      udiskie
      unzip
      unar
      veracrypt
      wget
      xmobar
      xorg.xprop
      youtube-dl-light
      zip
    ];

    keyboard = {
      layout = "us";
      options = ["compose:ralt" "compose:rwin" "ctrl:nocaps"];
    };

    file = {
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
