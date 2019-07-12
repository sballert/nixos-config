{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;

  time.timeZone = "Europe/Berlin";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.xserver = {
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

  users.users.sballert = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.sballert = {
    home = {
      packages = with pkgs; [ gnupg st ];
      file = {
        ".gnupg/sshcontrol".text = ''
          447910F828DF001601E7FAECF768DFA93DF87136
        '';
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
