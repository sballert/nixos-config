{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  nixpkgs = {
    overlays = with pkgs; [
      (self: super: {
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
      })
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";

  networking = {
    hostName = "nixos";
    wireless.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        111 2049 20048
      ];
      allowedUDPPorts = [
        111 2049 20048
      ];
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      xkbOptions = "compose:ralt,compose:rwin,ctrl:nocaps";
      displayManager.lightdm = {
        enable = true;
        greeters.gtk.enable = false;
        greeters.mini = {
          enable = true;
          user = "sballert";
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
      ultimate.enable = true;
      defaultFonts = {
        monospace = ["Roboto Mono"];
        sansSerif = ["Noto Sans Display"];
        serif = ["Noto Serif Display"];
      };
    };
    fonts = with pkgs; [
      noto-fonts
      roboto-mono
    ];
  };

  virtualisation.virtualbox.host.enable = true;

  programs = {
    slock.enable = true;
  };

  users.users.sballert = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "vboxusers"
    ];
  };

  home-manager.users.sballert = {
    home = {
      packages = with pkgs; [
        gnupg st xmobar
        pulseaudio-ctl
        pass
        udiskie
        libreoffice
        vagrant
      ];
      file = {
        ".gnupg/sshcontrol".text = ''
          447910F828DF001601E7FAECF768DFA93DF87136
        '';
        ".emacs.d/init.el".text = builtins.readFile ./init.el;
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
    };
    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./xmonad.hs;
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
      emacs = {
        enable = true;
        extraPackages = epkgs: with epkgs.melpaPackages; [
          use-package diminish
          evil evil-collection
          general
          which-key
          gruvbox-theme
          counsel
          evil-org org-bullets
          super-save
        ] ++ (with epkgs.orgPackages; [
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
