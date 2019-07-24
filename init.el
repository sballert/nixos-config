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
    :prefix "\\"
    :non-normal-prefix "M-\\")
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
    "&" 'async-shell-command
    "bd" 'kill-current-buffer)
  :config
  (setq line-number-mode t
        column-number-mode t
        save-interprogram-paste-before-kill t))

;; dired.el --- directory-browsing commands
(use-package dired
  :config
  (setq dired-auto-revert-buffer t
        dired-dwim-target t
        dired-listing-switches "-alh")
  (put 'dired-find-alternate-file 'disabled nil))

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
    "x" 'counsel-M-x))

;; https://github.com/abo-abo/swiper
;; Swiper - isearch with an overview
(use-package swiper :general (prefix-def "/s" 'swiper))

;; org-mode ====================================================================
;; https://orgmode.org/
;; Org mode is for keeping notes, maintaining TODO lists, planning projects,
;; and authoring documents with a fast and effective plain-text system.
(use-package org :demand t)

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

;; PHP =========================================================================
;; https://github.com/emacs-php/php-mode
;; A PHP mode for GNU Emacs
(use-package php-mode :mode ("\\.php$" . php-mode))

;; Theme =======================================================================
(require 'gruvbox)
(load-theme 'gruvbox t)

;; Finalize ====================================================================
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)
