{ config, pkgs, options, lib, ... }: let

################################################################################
  configDir = ./../config;

  wallpaper = builtins.fetchurl https://s3.amazonaws.com/psiu/wallpapers/heic1209a/heic1209a_desktop.jpg;

  pathToConfig = conf: configDir + "/${conf}";

  readConfig = conf: builtins.readFile (configDir + "/${conf}");

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ./../packages/overlays/mypackages.nix)
      (import ./../packages/overlays/overwrites.nix)
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
  };

################################################################################
in {
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
    ./../modules
  ];

  inherit nixpkgs;
################################################################################
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
################################################################################
  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };
################################################################################
  networking = {
    hostName = "nixos";
    wireless = {
      enable = true;
      interfaces = [ "wlp59s0" ];
    };
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
        9000 # php-debug
      ];
      allowedUDPPorts = [
      ];
    };
    hosts = {
      "127.0.0.1" = [
        "localhost"
        "redis"
        "postgres"
      ];
      "192.168.178.24" = [ "ev3dev" ];
      "10.51.51.16" = [ "*.dev7.silversurfer7.de" ];
    };
  };
################################################################################
  sound.enable = true;
################################################################################
  hardware = {
    bluetooth.enable = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };
################################################################################
  services = {
    undervolt = {
      enable = true;
      coreOffset = -140;
      gpuOffset = -75;
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
    udev.packages = with pkgs; [
      android-udev-rules
      onlykey-udev
    ];
  };
################################################################################
  fonts = {
    fontDir.enable = true;
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
      noto-fonts-emoji
    ];
  };
################################################################################
  virtualisation = {
    docker.enable = true;
  };
################################################################################
  programs = {
    adb.enable = true;
    slock.enable = true;
    gnupg.agent.enable = true;
    zsh.enable = true;
  };
################################################################################
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];
################################################################################
  i18n.extraLocaleSettings = {
    LC_COLLATE = "C";
  };
################################################################################
  users.users.sballert = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "docker"
      "adbusers"
    ];
    shell = "/run/current-system/sw/bin/zsh";
  };
################################################################################
  home-manager.users.sballert = import ./../home {
    inherit pkgs nixpkgs wallpaper pathToConfig readConfig lib;
  };
################################################################################

  nix.nixPath = let
    overlaysDir = builtins.toString ./../packages/overlays;
  in (options.nix.nixPath.default ++ [
    "nixpkgs-overlays=${overlaysDir}"
  ]);

################################################################################
  system.stateVersion = "21.05";
}
