{ pkgs, nixpkgs, wallpaper, pathToConfig, readConfig, ... }: {

  inherit nixpkgs;

################################################################################
  home = {
    packages = with pkgs; [
      gnupg st xmobar
      pulseaudio-ctl
      pass
      udiskie
      libreoffice
      vagrant
      xrandr-util
      session-menu
      nix-util
      xlogout
      toggle-touchpad
      gimp
      gnome3.dconf
      spotify
      xorg.xprop
      brightnessctl
      slack
      docker-compose
      youtube-dl-light
      bluetoothctl-menu
      backup
      gitAndTools.gitflow
    ];
    file = {
      ".gnupg/sshcontrol".text = ''
        447910F828DF001601E7FAECF768DFA93DF87136
      '';
      ".emacs.d/init.el".text = readConfig "init.el";
      ".config/xmobar/xmobarrc".text = readConfig "xmobarrc";
      ".ghci".text = readConfig "ghci";
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
  programs = {
    git = {
      enable = true;
      userName = "sballert";
      userEmail = "sballert@posteo.de";
      signing = {
        key = "0D13923C4C030FC9B916E001A9B01ECA2EF6466B";
        signByDefault = true;
      };
      extraConfig = {
        log.decorate = "full";
        github.user = "sballert";
      };
    };
    firefox.enable = true;
    google-chrome.enable = true;
    emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [
        pdf-tools
      ] ++ (with melpaPackages; [
        use-package diminish
        evil evil-collection
        general
        which-key
        gruvbox-theme
        counsel
        evil-org org-bullets
        super-save
        magit evil-magit
        nix-mode
        ws-butler
        php-mode
        web-mode
        fill-column-indicator
        haskell-mode
        shackle
        hydra
        password-store
        projectile
        nov
        org-drill
        json-mode
        markdown-mode
        yaml-mode
      ]) ++ (with orgPackages; [
        org-plus-contrib
      ]);
    };
    rofi = {
      enable = true;
      font = "Noto Sans Display 10";
      theme = builtins.toPath "${pkgs.gruvbox-rofi}/gruvbox-dark.rasi";
    };
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
    feh = {
      enable = true;
      keybindings = { zoom_in = "j"; zoom_out = "k"; };
    };
  };
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
