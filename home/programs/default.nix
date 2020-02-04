{ pkgs, ... }: {
  browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  direnv.enable = true;

  emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      pdf-tools
    ] ++ (with melpaPackages; [
      counsel
      diminish
      direnv
      evil
      evil-collection
      evil-org
      fill-column-indicator
      general
      gruvbox-theme
      haskell-mode
      hydra
      json-mode
      magit evil-magit
      markdown-mode
      nix-mode
      nov
      org-bullets
      org-drill
      password-store
      php-mode
      projectile
      shackle
      super-save
      use-package
      web-mode
      which-key
      ws-butler
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

  fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    defaultOptions = [
      "--layout reverse"
      "--height 40%"
    ];
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat {}'" ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    changeDirWidgetOptions = [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
  };

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

  zsh = import ./zsh.nix { inherit pkgs; };
}
