{ pkgs, ... }:

with pkgs;

{
  enable = true;

  extraPackages = epkgs: with epkgs; [
    pdf-tools
  ] ++ (with melpaPackages; [
    company
    company-lsp
    counsel
    dap-mode
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
    lsp-mode
    lsp-ui
    lsp-ivy
    magit evil-magit
    markdown-mode
    nix-mode
    nov
    org-bullets
    org-drill
    password-store
    php-mode
    projectile
    rainbow-delimiters
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
