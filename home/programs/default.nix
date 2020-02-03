{ pkgs, ... }: {
  browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

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

  feh = {
    enable = true;
    keybindings = { zoom_in = "j"; zoom_out = "k"; };
  };

  firefox.enable = true;

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

  google-chrome.enable = true;

  rofi = {
    enable = true;
    font = "Noto Sans Display 10";
    theme = builtins.toPath "${pkgs.gruvbox-rofi}/gruvbox-dark.rasi";
  };
}
