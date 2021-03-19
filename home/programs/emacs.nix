{ pkgs, ... }:

with pkgs;

{
  enable = true;

  extraPackages = epkgs: with epkgs; [
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
    gruvbox-theme
    haskell-mode
    hydra
    json-mode
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
    nov
    ob-restclient
    org-bullets
    org-drill
    password-store
    php-mode
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
