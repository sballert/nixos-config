{ pkgs, ... }:

with pkgs;

{
  enable = true;

  overrides = let

    compileEmacsFiles = pkgs.callPackage my.lib.compileEmacsFiles;

  in self: _: rec {
    clang-format-plus = compileEmacsFiles {
      name = "clang-format-plus";
      version = "20190824.221";

      src = fetchFromGitHub {
        owner = "SavchenkoValeriy";
        repo = "emacs-clang-format-plus";
        rev = "ddd4bfe1a13c2fd494ce339a320a51124c1d2f68";
        sha256 =  "0y97f86qnpcscwj41icb4i6j40qhvpkyhg529hwibpf6f53j7ckl";
      };

      buildInputs = with self.melpaPackages; [ clang-format ];
    };
  };

  extraPackages = epkgs: with epkgs; [
    auctex
    js2-mode
    pdf-tools
  ] ++ (with melpaPackages; [
    aggressive-indent
    benchmark-init
    clang-format
    company
    counsel
    dap-mode
    dictcc
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
    ivy-bibtex
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
    nixpkgs-fmt
    nodejs-repl
    nov
    ob-restclient
    org-bullets
    org-drill
    org-noter
    org-ref
    org-roam
    org-roam-bibtex
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
  ]) ++ [
    clang-format-plus
  ];
}
