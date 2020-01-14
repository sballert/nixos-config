;; Initialization ==============================================================
(eval-and-compile
  (setq gc-cons-threshold 402653184
        gc-cons-percentage 0.6))

;; package.el ==================================================================
(eval-and-compile
  (setq package--init-file-ensured t
        package-enable-at-startup nil))

;; use-package =================================================================
(eval-when-compile
  (require 'use-package))

(eval-and-compile
  (setq use-package-always-defer t)
  (require 'diminish))

;; general.el ==================================================================
;; https://github.com/noctuid/general.el
;; More convenient key definitions in emacs
(use-package general
  :demand t
  :config
  (general-create-definer prefix-def
    :keymaps 'override
    :states '(normal insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC"
    :prefix-command 'prefix-command
    :prefix-map 'prefix-map)
  (general-create-definer local-def
    :states '(normal insert emacs)
    :prefix "SPC SPC"
    :non-normal-prefix "M-SPC SPC")
  (prefix-def
    "/" '(:ignore t :which-key "search")
    "b" '(:ignore t :which-key "buffer")
    "f" '(:ignore t :which-key "find")
    "ff" 'find-file
    "w" '(:ignore t :which-key "window")
    "Q" 'save-buffers-kill-terminal))

;; https://github.com/justbur/emacs-which-key
;; Emacs package that displays available keybindings in popup
(use-package which-key
  :diminish
  :hook (after-init . which-key-mode)
  :general
  (general-def :keymaps 'help-map "j" 'which-key-show-top-level)
  :config
  (setq which-key-sort-uppercase-first nil
        which-key-sort-order 'which-key-prefix-then-key-order-reverse))

;; hydra =======================================================================
;; https://github.com/abo-abo/hydra
;; make Emacs bindings that stick around
(use-package hydra :demand t)

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

;; evil-mode ===================================================================
;; https://github.com/emacs-evil/evil
;; The extensible vi layer for Emacs.
(use-package evil
  :hook (after-init . evil-mode)
  :general
  (prefix-def
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wo" 'delete-other-windows
    "ws" 'evil-window-split
    "wv" 'evil-window-vsplit
    "wq" 'evil-quit
    "wH" 'evil-window-decrease-width
    "wL" 'evil-window-increase-width
    "wJ" 'evil-window-decrease-height
    "wK" 'evil-window-increase-height)
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil))

;; https://github.com/emacs-evil/evil-collection
;; A set of keybindings for evil-mode
(use-package evil-collection
  :demand t
  :after (evil)
  :config
  (setq evil-collection-setup-minibuffer t)
  (evil-collection-init))

;; Builtins ====================================================================
(setq-default major-mode 'text-mode
              indent-tabs-mode nil)

;; subr.el --- basic lisp subroutines for Emacs
(fset 'yes-or-no-p 'y-or-n-p)

;; files.el --- file input and output commands for Emacs
(use-package files
  :demand t
  :config
  (setq save-silently t
        large-file-warning-threshold 100000000
        auto-save-default nil
        make-backup-files nil))

;; menu-bar.el --- define a default menu bar
(use-package menu-bar :commands menu-bar-mode :config (menu-bar-mode -1))

;; scroll-bar.el --- window system-independent scroll bar support
(use-package scroll-bar :commands scroll-bar-mode :config (scroll-bar-mode -1))

;; tool-bar.el --- setting up the tool bar
(use-package tool-bar :commands tool-bar-mode :config (tool-bar-mode -1))

;; startup.el --- process Emacs shell arguments
(eval-after-load "startup"
  (setq inhibit-startup-screen t
        initial-scratch-message ""))

;; frame.el --- multi-frame management independent of window systems
(use-package frame
  :config
  (add-to-list 'default-frame-alist '(font . "Roboto Mono-10"))
  (blink-cursor-mode 0)
  (setq-default cursor-in-non-selected-windows nil))

;; simple.el --- basic editing commands for Emacs
(use-package simple
  :general
  (prefix-def
    "!" 'shell-command
    ":" 'eval-expression
    "&" 'async-shell-command
    "u" 'universal-argument
    "bd" 'kill-current-buffer)
  :config
  (setq line-number-mode t
        column-number-mode t
        save-interprogram-paste-before-kill t))

;; dired.el --- directory-browsing commands
(use-package dired
  :commands (dired-dotfiles-toggle)
  :config
  (defun dired-mode-setup ()
    "Dired setup hook"
    (dired-hide-details-mode 1))

  (defun dired-toggle-dotfiles ()
    "Show/hide dot-files"
    (interactive)
    (when (equal major-mode 'dired-mode)
      (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
          (progn
            (set (make-local-variable 'dired-dotfiles-show-p) nil)
            (message "h")
            (dired-mark-files-regexp "^\\\.")
            (dired-do-kill-lines))
        (progn (revert-buffer)      ; otherwise just revert to re-show
               (set (make-local-variable 'dired-dotfiles-show-p) t)))))

  (add-hook 'dired-mode-hook 'dired-mode-setup)
  (setq dired-auto-revert-buffer t
        dired-dwim-target t
        dired-listing-switches "-alh --group-directories-first")
  (put 'dired-find-alternate-file 'disabled nil))

;; dired-x.el --- extra Dired functionality
(use-package dired-x
  :after (dired)
  :config
  (setq dired-guess-shell-alist-user '(("\\.mkv\\'\\|\\.mp4\\'" "mpv")))
  :general
  (prefix-def
    "d" 'dired-jump
    "D" 'dired-jump-other-window))

;; whitespace.el --- minor mode to visualize TAB, (HARD) SPACE, NEWLINE
(use-package whitespace
  :diminish
  :hook ((prog-mode text-mode) . whitespace-mode)
  :config (setq whitespace-style '(face trailing tabs tab-mark)))

;; recentf.el --- setup a menu of recently opened files
(use-package recentf
  :demand t
  :hook ((after-init) . recentf-mode)
  :config
  (setq recentf-max-saved-items 1000
        recentf-max-menu-items 200))

;; undo-tree.el --- Treat undo history as a tree
(use-package undo-tree :diminish)

;; autorevert.el --- revert buffers when files on disk change
(use-package autorevert :diminish
  :hook (after-init . global-auto-revert-mode)
  :config (setq auto-revert-check-vc-info t))

;; eldoc.el --- Show function arglist or variable docstring in echo area
(use-package eldoc :diminish)

;; display-line-numbers.el --- interface for display-line-numbers
(use-package display-line-numbers
  :hook (prog-mode . display-line-numbers-mode)
  :config (setq display-line-numbers-type 'relative))

;; align.el --- align text to a specific column, by regexp
(use-package align
  :general
  (local-def
    :keymaps '(prog-mode-map)
    "a" 'align-regexp))

;; grep.el --- run `grep' and display the results
(use-package grep
  :general
  (prefix-def
    "/g" '(:ignore t :which-key "grep")
    "/gf" 'grep-find
    "/gl" 'lgrep
    "/gr" 'rgrep
    "/gg" 'grep))

;; find-dired.el --- run a `find' command and dired the output
(use-package find-dired
  :general
  (prefix-def
    "fD" 'find-dired
    "fd" 'find-grep-dired))

;; tramp.el --- Transparent Remote Access, Multiple Protocol
(use-package tramp
  :general
  (prefix-def "fs" 'find-file-as-sudo)
  :commands (find-file-as-sudo)
  :config
  (defun find-file-as-sudo (file-name)
    "Like find file, but opens the file as root."
    (interactive "FFind File As Sudo: ")
    (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
      (find-file tramp-file-name))))

;; term.el --- general command interpreter in a window stuff
(use-package term
  :general
  (prefix-def
    "t" 'ansi-term-default)
  :commands (ansi-term-default)
  :config
  (defun ansi-term-default ()
    (interactive)
    (ansi-term shell-file-name)))

;; help.el --- help commands for Emacs
(use-package help
  :general
  (prefix-def
    "h" '(:ignore t :which-key "help")

    "hm" 'describe-mode
    "hf" 'describe-function
    "hv" 'describe-variable
    "hk" 'describe-key

    "ha" 'apropos
    "hc" 'apropos-command
    "hd" 'apropos-documentation
    "hl" 'apropos-library
    "hu" 'apropos-user-options
    "hV" 'apropos-value

    "hi" 'info))

;; Swiper ======================================================================
;; https://github.com/abo-abo/swiper
;; Ivy - a generic completion frontend for Emacs
(use-package ivy
  :diminish
  :hook (after-init . ivy-mode)
  :general
  (general-def 'normal  'ivy-occur-mode-map
    "<escape>" 'minibuffer-keyboard-quit)
  (prefix-def "bb" 'ivy-switch-buffer)
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "
        ivy-use-selectable-prompt t))

;; https://github.com/abo-abo/swiper
;; Various completion functions using Ivy
(use-package counsel
  :diminish
  :hook (after-init . counsel-mode)
  :general
  (prefix-def
    "r" 'counsel-recentf
    "/gg" 'counsel-git-grep
    "x" 'counsel-M-x))

;; https://github.com/abo-abo/swiper
;; Swiper - isearch with an overview
(use-package swiper :general (prefix-def "/s" 'swiper))

;; org-mode ====================================================================
;; https://orgmode.org/
;; Org mode is for keeping notes, maintaining TODO lists, planning projects,
;; and authoring documents with a fast and effective plain-text system.
(use-package org :demand t
  :general
  (local-def
    :keymaps '(org-mode-map)
    "t" 'org-babel-tangle)
  :config
  (let ((languages '(haskell)))
    (org-babel-do-load-languages
     'org-babel-load-languages
     (mapcar (lambda (mode) `(,mode . t)) languages)))
  (setq org-confirm-babel-evaluate nil)
  (add-hook 'org-mode-hook 'auto-fill-mode))

;; https://orgmode.org/
;; Dynamic indentation for Org
(use-package org-indent :diminish :hook (org-mode . org-indent-mode))

;; https://github.com/sabof/org-bullets
;; utf-8 bullets for org-mode
(use-package org-bullets :hook (org-mode . org-bullets-mode))

;; https://github.com/Somelauw/evil-org-mode
;; Supplemental evil-mode keybindings to emacs org-mode
(use-package evil-org
  :diminish
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme '(navigation
                            insert
                            textobjects
                            additional
                            shift
                            todo
                            heading
                            calendar)))

;; https://github.com/Somelauw/evil-org-mode
;; evil keybindings for org-agenda-mode
(use-package evil-org-agenda
  :demand t
  :after (evil-org)
  :config (evil-org-agenda-set-keys))

(use-package org-drill
  :general
  (local-def
    :keymaps '(org-mode-map)
    "d" '(:ignore t :which-key "org-drill")
    "d SPC" 'org-drill
    "dt" 'org-drill-tree
    "dd" 'org-drill-directory
    "dr" 'org-drill-resume)
  :config
  (add-to-list 'org-modules 'org-drill))

;; Magit =======================================================================
;; https://github.com/magit/magit
;; magit.el --- A Git porcelain inside Emacs
(use-package magit
  :general
  (prefix-def
    "g" '(:ignore t :which-key "magit")
    "g SPC" 'magit-status
    "gf" 'magit-log-buffer-file))

;; https://github.com/emacs-evil/evil-magit
;; Black magic or evil keys for magit
(use-package evil-magit :diminish :demand t :after (evil magit))

;; Projectile ==================================================================
;; https://github.com/bbatsov/projectile
;; Project Interaction Library for Emacs
(use-package projectile
  :hook (after-init . projectile-mode)
  :general
  (prefix-def
    "p" '(:ignore t :which-key "projectile")
    "p SPC" 'projectile-find-file

    "pg" 'projectile-grep
    "pr" 'projectile-replace
    "pp" 'projectile-command-map

    "pc" 'projectile-compile-project
    "p!" 'projectile-run-shell-command-in-root
    "p&" 'projectile-run-async-shell-command-in-root

    "ps" '(:ignore t :which-key "switch")
    "psp" 'projectile-switch-project
    "pso" 'projectile-switch-open-project

    "/gp" 'projectile-grep

    "f SPC" 'projectile-find-file)
  :config
  (setq projectile-completion-system 'ivy
        projectile-switch-project-action 'projectile-dired
        projectile-mode-line-function '(lambda () (format " [%s]" (projectile-project-name)))
        projectile-project-search-path '("~/projects/"
                                         "~/s7/repos/"
                                         "~/school/")))

;; NixOS =======================================================================
;; https://github.com/NixOS/nix-mode
;; An Emacs major mode for editing Nix expressions.
(use-package nix-mode
  :mode "\\.nix$"
  :general
  (prefix-def
    "N" '(:ignore t :which-key "nix")
    "Nb" 'nix-build
    "NR" 'nix-repl
    "Ns" 'nix-shell
    "Nu" 'nix-unpack)
  :config (setq nix-indent-function 'nix-indent-line))

;; https://github.com/NixOS/nix-mode
;; nix-drv-mode.el --- Major mode for viewing .drv files
(use-package nix-drv-mode :mode "\\.drv\\'")

;; Misc ========================================================================
;; https://github.com/bbatsov/super-save
;; Save Emacs buffers when they lose focus
(use-package super-save
  :diminish
  :hook (after-init . super-save-mode)
  :config
  (setq super-save-auto-save-when-idle t))

;; https://github.com/lewang/ws-butler
;; Unobtrusively trim extraneous white-space *ONLY* in lines edited.
(use-package ws-butler :diminish :hook (after-init . ws-butler-global-mode))

;; https://github.com/alpaker/Fill-Column-Indicator
;; An Emacs minor mode that graphically indicates the fill column.
(use-package fill-column-indicator
  :hook (prog-mode . fci-mode)
  :config
  (setq fci-rule-width 1
        fci-rule-column 80
        fci-rule-color "#665c54"))

;; https://github.com/wasamasa/shackle
;; Enforce rules for popup windows
(use-package shackle
  :hook (after-init . shackle-mode)
  :config
  (defun shackle--smart-split-dir ()
    (if (>= (window-pixel-height)
           (window-pixel-width))
        'below
      'right))
  (defun shackle-dynamic-tyling (buffer alist plist)
    (let
        ((frame (shackle--splittable-frame))
         (window (if (eq (shackle--smart-split-dir) 'below)
                     (split-window-below)
                   (split-window-right))))
      (prog1
          (window--display-buffer buffer window 'window alist display-buffer-mark-dedicated)
        (when window
          (setq shackle-last-window window
                shackle-last-buffer buffer))
        (unless (cdr (assq 'inhibit-switch-frame alist))
          (window--maybe-raise-frame frame)))))
  (defun shackle-org-src-pop-to-buffer (buffer _context)
    "Open the src-edit in a way that shackle can detect."
    (if (eq org-src-window-setup 'switch-invisibly)
        (set-buffer buffer)
      (pop-to-buffer buffer)))
  (advice-add #'org-src-switch-to-buffer :override #'shackle-org-src-pop-to-buffer)
  (setq shackle-rules
        '(("*Help*" :select t :other t)
          ("\\*Org Src[][[:space:][:word:].]*\\*"
           :regexp t
           :select t
           :custom shackle-dynamic-tyling))))

;; https://github.com/wasamasa/nov.el
;; nov.el --- Featureful EPUB reader mode
(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-text-width 80)
  (defun my-nov-font-setup ()
    (face-remap-add-relative 'variable-pitch :family "Liberation Serif"
                             :height 1.0))
  (add-hook 'nov-mode-hook 'my-nov-font-setup))

;; PDF Tools ===================================================================
;; https://github.com/politza/pdf-tools
;; Emacs support library for PDF files.
(use-package pdf-tools
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :functions (pdf-tools-disable-cursor pdf-tools-advice-evil-refresh-cursor)
  :general (local-def :keymaps '(pdf-view-mode-map) "o" 'pdf-occur)
  :config
  (defun pdf-tools-advice-evil-refresh-cursor (evil-refresh-cursor &rest args)
    (if (and (not (derived-mode-p 'evil-view-mode)) evil-default-cursor)
        (apply evil-refresh-cursor args)
      nil))
  (advice-add 'evil-refresh-cursor :around #'pdf-tools-advice-evil-refresh-cursor)
  (defun pdf-tools-disable-cursor ()
    (setq-local evil-default-cursor nil))
  (add-hook 'pdf-view-mode-hook #'pdf-tools-disable-cursor)
  (add-hook 'pdf-view-mode-hook #'pdf-isearch-minor-mode)
  (add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode))

;; https://github.com/politza/pdf-tools
;; pdf-isearch --- Isearch in pdf buffers.
(use-package pdf-isearch :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-occur --- Display matching lines of PDF documents.
(use-package pdf-occur :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-links.el --- Handle PDF links.
(use-package pdf-links :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-annot.el --- Annotation support for PDF files.
(use-package pdf-annot :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-outline.el --- Outline for PDF buffer
(use-package pdf-outline :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-sync.el --- Use synctex to correlate LaTeX-Sources with PDF positions.
(use-package pdf-sync :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-virtual.el --- Virtual PDF documents
(use-package pdf-virtual :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-history.el --- A simple stack-based history in PDF buffers.
(use-package pdf-history :demand t :after (pdf-tools))

;; https://github.com/politza/pdf-tools
;; pdf-misc.el --- Miscellaneous commands for PDF buffer.
(use-package pdf-misc :demand t :after (pdf-tools))

;; Pass ========================================================================
;; https://github.com/zx2c4/password-store
;; This package provides functions for working with pass ("the standard Unix password manager").
(use-package password-store
  :general
  (prefix-def
    "P" '(:ignore t :which-key "password-store")
    "Pd" 'password-store-remove
    "Pe" 'password-store-edit
    "Pg" 'password-store-get
    "Pi" 'password-store-insert
    "Pm" 'password-store-rename
    "Pu" 'password-store-url
    "PC" 'password-store-clear
    "PG" 'password-store-generate
    "PI" 'password-store-init
    "Pc" 'password-store-copy)
  :config
  (setq password-store-password-length 30))

;; PHP =========================================================================
;; https://github.com/emacs-php/php-mode
;; A PHP mode for GNU Emacs
(use-package php-mode :mode ("\\.php$" . php-mode))

;; https://github.com/ahungry/geben
;; Geben - PHP xdebug for Emacs
(use-package geben :demand t :after (php-mode)
  :general
  (local-def
    :keymaps '(php-mode-map)
    "g SPC" 'hydra-geben-run/body
    "gg" 'geben
    "gE" 'geben-end
    "gA" 'geben-add-current-line-to-predefined-breakpoints
    "gC" 'geben-clear-predefined-breakpoints
    "gV" 'geben-predefined-breakpoints
    "gb" 'geben-set-breakpoint-line
    "gB" 'geben-breakpoint-menu
    "gu" 'geben-unset-breakpoint-line
    "gU" 'geben-clear-breakpoints
    "ge" 'geben-eval-expression
    "gl" 'geben-eval-current-line
    "gw" 'geben-where
    "gv" 'geben-display-context
    "gt" 'geben-show-backtrace
    "gp" 'geben-show-brackpoint-list
    "g?" 'geben-mode-help)
  :config
  (setq geben-path-mappings
        '(("/home/sballert/s7/repos/olimar" "/var/www/olimar")
          ("/home/sballert/s7/repos/ameropa" "/var/www/ameropa"))))

(defhydra hydra-geben-run ()
    "geben-run"
    ("r" geben-run "run")
    ("c" geben-run-to-cursor "run to cursor")
    ("n" geben-step-over "step over")
    ("o" geben-stepout "step out")
    ("a" geben-step-again "step again")
    ("i" geben-step-into "into")
    ("e" geben-eval-expression "eval expression")
    ("v" geben-display-context "display context")
    ("u" geben-unset-breakpoint-line "unset breakpoint")
    ("s" geben-stop "stop" :exit t))

;; HTML ========================================================================
;; https://github.com/fxbois/web-mode
;; major mode for editing web templates
(use-package web-mode :mode("\\.twig$" "\\.html?$"))

;; Haskell =====================================================================
;; https://github.com/haskell/haskell-mode
;; Emacs mode for Haskell
(use-package haskell-mode
  :general
  (local-def
    :keymaps '(haskell-mode-map)
    "i" 'haskell-navigate-imports
    "," 'haskell-mode-format-imports
    "s" 'haskell-sort-imports)
  :init (load "haskell-mode-autoloads")
  :mode ("\\.hs$" . haskell-mode))

;; Theme =======================================================================
(require 'gruvbox)
(load-theme 'gruvbox t)

;; Finalize ====================================================================
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)
