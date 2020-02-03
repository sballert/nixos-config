{ config, pkgs, ... }: let

################################################################################
  configDir = ./config;

  wallpaper = builtins.fetchurl https://s3.amazonaws.com/psiu/wallpapers/heic1209a/heic1209a_desktop.jpg;

  pathToConfig = conf: configDir + "/${conf}";

  readConfig = conf: builtins.readFile (configDir + "/${conf}");

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: let
        inherit (super) stdenv fetchFromGitHub;
      in rec {
        slock = super.slock.override {
          conf = readConfig "slock.h";
        };
        st = super.st.override {
          conf = readConfig "st.h";
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
        bluetoothctl-menu = stdenv.mkDerivation {
          name = "bluetoothctl-menu";
          buildInputs = [ self.makeWrapper  ];
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/bluetoothctl-menu.sh} $out/bin/bluetoothctl-menu
            wrapProgram $out/bin/bluetoothctl-menu \
            --prefix PATH : "${stdenv.lib.makeBinPath [ self.libnotify
                                                        self.rofi
                                                        self.bluez
                                                        self.gawk
                                                        self.gnugrep ]}"
          '';
        };
        backup = stdenv.mkDerivation {
          name = "backup";
          buildInputs = [ self.rsync ];
          unpackPhase = ":";
          installPhase = ''
            install -m755 -D ${./scripts/backup.sh} $out/bin/backup
          '';
        };
      })
    ];
  };

################################################################################
in {
  imports = [
    ./hardware-configuration.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  inherit nixpkgs;
################################################################################
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
################################################################################
  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };
################################################################################
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
    hosts = {
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

    brightnessctl.enable = true;
  };
################################################################################
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
    udev.packages = [ pkgs.android-udev-rules ];
  };
################################################################################
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
################################################################################
  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
  };
################################################################################
  programs = {
    adb.enable = true;
    slock.enable = true;
    gnupg.agent.enable = true;
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
      "vboxusers"
      "video"
      "docker"
      "adbusers"
    ];
  };
################################################################################
  home-manager.users.sballert = import ./home {
    inherit pkgs nixpkgs wallpaper pathToConfig readConfig;
  };
################################################################################
  system.stateVersion = "19.09";
}
