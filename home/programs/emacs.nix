{ pkgs, ... }:

with pkgs;

{
  enable = true;

  extraPackages = epkgs: with epkgs; [
    pdf-tools
  ] ++ (with melpaPackages; [
    aggressive-indent
    company
    company-lsp
    counsel
    dap-mode
    diminish
    direnv
    evil
    evil-collection
    evil-magit
    evil-org
    fill-column-indicator
    flycheck
    general
    gruvbox-theme
    haskell-mode
    hydra
    json-mode
    lispy
    lispyville
    lsp-mode
    lsp-ui
    lsp-ivy
    magit
    magit-gitflow
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
    yasnippet
  ]) ++ (with orgPackages; [
    org-plus-contrib
  ]);
}
