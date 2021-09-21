{ config, pkgs, options, lib, ... }: let
################################################################################
  util = import ./util.nix {};
################################################################################
in with util; {
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
    dhcpcd.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };

    hosts = {
      "127.0.0.1" = [ "localhost"];
      "192.168.178.24" = [ "ev3dev" ];
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
      my.onlykey-udev
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
  nix.nixPath = let
    overlaysDir = builtins.toString ./../packages/overlays;
  in (options.nix.nixPath.default ++ [
    "nixpkgs-overlays=${overlaysDir}"
  ]);
################################################################################
  system.stateVersion = "21.11";
}
