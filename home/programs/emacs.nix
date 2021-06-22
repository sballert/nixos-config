{ pkgs, ... }:

with pkgs;

{
  enable = true;

  extraPackages = epkgs: with epkgs; [
    js2-mode
    pdf-tools
  ] ++ (with melpaPackages; [
    aggressive-indent
    company
    counsel
    dap-mode
    diminish
    direnv
    es-mode
    evil
    evil-collection
    evil-org
    fill-column-indicator
    flycheck
    general
    geiser
    geiser-guile
    gruvbox-theme
    haskell-mode
    hydra
    json-mode
    kotlin-mode
    lispy
    lispyville
    lsp-haskell
    lsp-mode
    lsp-ui
    lsp-ivy
    magit
    magit-gitflow
    markdown-mode
    nix-mode
    nodejs-repl
    nov
    ob-restclient
    org-bullets
    org-drill
    password-store
    php-mode
    prettier
    projectile
    rainbow-delimiters
    restclient
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
