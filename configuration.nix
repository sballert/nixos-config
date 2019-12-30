{ config, pkgs, ... }: let

  wallpaper = builtins.fetchurl https://s3.amazonaws.com/psiu/wallpapers/heic1209a/heic1209a_desktop.jpg;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: let
        inherit (super) stdenv fetchFromGitHub;
      in rec {
        slock = super.slock.override {
          conf = builtins.readFile ./slock.h;
        };
        st = super.st.override {
          conf = builtins.readFile ./st.h;
        };
        gruvbox-rofi = stdenv.mkDerivation {
          name = "gruvbox-rofi";
          src = fetchFromGitHub {
            owner = "bardisty";
            repo = "gruvbox-rofi";
            rev = "0b4cf703087e2150968826b7508cf119437eba7a";
            sha256 = "18rkm03p08bjkgiqh599pcvyqxmwldza600pq3sinmpk4sv4s1cw";
          };
          installPhase = ''
            install -d $out
            install -m755 -D $src/*.rasi $out
          '';
        };
        xrandr-util = stdenv.mkDerivation {
          name = "xrandr-util";
          buildInputs = [ self.xorg.xrandr ];
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/xrandr-util.sh} $out/bin/xrandr-util
          '';
        };
        nix-util = stdenv.mkDerivation {
          name = "nix-util";
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/nix-util.sh} $out/bin/nix-util
          '';
        };
        xlogout = stdenv.mkDerivation {
          name = "xlogout";
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/xlogout.sh} $out/bin/xlogout
          '';
        };
        session-menu = stdenv.mkDerivation {
          name = "session-menu";
          buildInputs = [ self.rofi xlogout ];
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/session-menu.sh} $out/bin/session-menu
          '';
        };
        toggle-touchpad = stdenv.mkDerivation {
          name = "toggle-touchpad";
          buildInputs = [ self.xorg.xinput ];
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/toggle-touchpad.sh} $out/bin/toggle-touchpad
          '';
        };
      })
    ];
  };

in {
  imports = [
    ./hardware-configuration.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  inherit nixpkgs;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  networking = {
    hostName = "nixos";
    wireless.enable = true;
    dhcpcd = {
      enable = true;
      runHook = ''
        if [[ $reason =~ BOUND ]]; then
          if grep -q '^domain silversurfer7.de' /etc/resolv.conf; then
            echo "Add default route for domain silversurfer7.de"
            ${pkgs.iproute}/bin/ip route add default via 192.168.100.1
          fi
        fi
      '';
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        111 2049 20048
        9000
      ];
      allowedUDPPorts = [
        111 2049 20048
      ];
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;

  hardware = {
    bluetooth.enable = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    brightnessctl.enable = true;
  };

  services = {
    undervolt = {
      enable = true;
      coreOffset = "-140";
      gpuOffset = "-75";
    };
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      xkbOptions = "compose:ralt,compose:rwin,ctrl:nocaps";
      desktopManager.xterm.enable = true;
      displayManager.lightdm = {
        enable = true;
        background = wallpaper;
        greeters.gtk.enable = false;
        greeters.mini = {
          enable = true;
          user = "sballert";
          extraConfig = ''
            [greeter]
            show-password-label = false
            [greeter-theme]
            text-color = "#ebdbb2"
            error-color = "#fb4934"
            window-color = "#282828"
            border-color = "#665c54"
            password-color = "#ebdbb2"
            password-background-color = "#3c3836"
          '';
        };
      };
    };
    nfs.server = {
      enable = true;
      extraNfsdConfig = ''
        udp=y
      '';
    };
  };

  fonts = {
    enableFontDir = true;
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        monospace = ["Roboto Mono"];
        sansSerif = ["Noto Sans Display"];
        serif = ["Noto Serif Display"];
      };
    };
    fonts = with pkgs; [
      noto-fonts
      roboto-mono
      emacs-all-the-icons-fonts
    ];
  };

  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
  };

  programs = {
    slock.enable = true;
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  users.users.sballert = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "vboxusers"
      "video"
      "docker"
    ];
  };

  home-manager.users.sballert = {
    inherit nixpkgs;
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
      ];
      file = {
        ".gnupg/sshcontrol".text = ''
          447910F828DF001601E7FAECF768DFA93DF87136
        '';
        ".emacs.d/init.el".text = builtins.readFile ./init.el;
        ".config/xmobar/xmobarrc".text = builtins.readFile ./xmobarrc;
      };
    };
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
    };
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
  };

  system.stateVersion = "19.09";
}
