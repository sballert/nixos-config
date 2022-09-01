{ pkgs, lib, config, ... }: let

  myLib = pkgs.my.lib;

in {

  nixpkgs = import ./../nixpkgs/config.nix;

################################################################################
  home = {
    stateVersion = "22.05";
    packages = with pkgs; [
      my.backup
      my.bluetoothctl-menu
      my.nix-util
      my.session-menu
      my.toggle-screen-locker
      my.toggle-touchpad
      my.xlogout
      my.xrandr-util
      anystyle-cli
      aria2
      bat
      brightnessctl
      exa
      fd
      gcc
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
      tdesktop
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
      ".emacs.d/init.el".text = myLib.readConfig "init.el";
      ".emacs.d/alarm.wav".source = builtins.fetchurl config.alarm-sound.wavUrl;
      ".ghci".text = myLib.readConfig "ghci";
      ".guile".text = myLib.readConfig "guile";
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
      config = myLib.pathToConfig "xmonad.hs";
    };
    initExtra = ''
      feh --bg-scale ${builtins.fetchurl config.wallpaper.imageUrl} &
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
  programs = import ./programs { inherit pkgs lib; };
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
