{ pkgs, ... }:

with pkgs;

{
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
    flycheck
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
}
