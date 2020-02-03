{ pkgs, nixpkgs, wallpaper, ... }: {

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
    ];
    file = {
      ".gnupg/sshcontrol".text = ''
        447910F828DF001601E7FAECF768DFA93DF87136
      '';
      ".emacs.d/init.el".text = builtins.readFile ./init.el;
      ".config/xmobar/xmobarrc".text = builtins.readFile ./xmobarrc;
      ".ghci".text = builtins.readFile ./ghci;
    };
  };
################################################################################
  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
    xcape = {
      enable = true;
      mapExpression = {
        Control_L = "Escape";
      };
    };
    screen-locker = {
      enable = true;
      lockCmd = "slock";
    };
    udiskie = {
      enable = true;
      tray = "never";
    };
    compton = {
      enable = true;
      opacityRule = [
        "95:class_g = 'st-256color'"
      ];
      blur = false;
      fade = true;
      shadow = false;
    };
    unclutter = {
      enable = true;
    };
    flameshot = {
      enable = true;
    };
    dunst = {
      enable = true;
      settings = {
        global = {
          font = "Noto Sans Display 10";
          markup = "yes";
          plain_text = "no";

          format = "<b>%s</b>\n%b";
          sort = "no";
          indicate_hidden = "yes";
          alignment = "center";
          bounce_freq = 0;
          show_age_threshold = -1;
          word_wrap = "yes";
          ignore_newline = "no";
          stack_duplicates = "yes";
          hide_duplicates_count = "yes";

          geometry = "300x50-15+49";
          shrink = "no";
          transparency = 0;
          idle_threshold = 0;
          monitor = 0;
          follow = "none";
          sticky_history = "no";
          history_length = 15;
          show_indicators = "no";
          line_height = 3;
          separator_height = 2;
          padding = 6;
          horizontal_padding = 6;
          separator_color = "frame";
          startup_notification = "false";
          icon_position = "off";
          max_icon_size = 80;

          frame_color = "#928374";
          frame_width = 1;
        };
        urgency_low = {
          foreground = "#ebdbb2";
          background = "#3c3836";
          timeout = 3;
        };
        urgency_normal = {
          foreground = "#ebdbb2";
          background = "#3c3836";
          timeout = 5;
        };
        urgency_critical = {
          foreground = "#ebdbb2";
          background = "#3c3836";
        };
      };
    };
  };
################################################################################
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
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
        geben
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
