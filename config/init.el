;;; init.el --- my Emacs configuration

;; Copyright (C) 2020 sballert

;; Author: sballert <sballert@posteo.de>

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

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

(require 'benchmark-init)
(add-hook 'after-init-hook 'benchmark-init/deactivate)

;; general.el ==================================================================
;; https://github.com/noctuid/general.el
;; More convenient key definitions in emacs
(eval-and-compile
  (require 'general))

(eval-when-compile
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
    :non-normal-prefix "M-SPC SPC"))

(eval-and-compile
  (prefix-def
    "/" '(:ignore t :which-key "search")
    "b" '(:ignore t :which-key "buffer")
    "f" '(:ignore t :which-key "find")
    "m" '(:ignore t :which-key "more")
    "ff" 'find-file
    "bD" 'kill-buffer
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
(eval-and-compile
  (require 'hydra))

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
    "wK" 'evil-window-increase-height
    "mm" 'evil-show-marks)
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (require 'goto-chg)
  (fset 'evil-redirect-digit-argument 'ignore))


;; https://github.com/emacs-evil/evil-collection
;; A set of keybindings for evil-mode
(use-package evil-collection
  :demand t
  :commands (evil-collection-init)
  :after (evil)
  :custom
  (evil-collection-company-use-tng nil)
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init)
  (diminish 'evil-collection-unimpaired-mode))

;; Builtins ====================================================================
(setq-default major-mode 'text-mode
              indent-tabs-mode nil)

;; subr.el --- basic lisp subroutines for Emacs
(fset 'yes-or-no-p 'y-or-n-p)

(setq user-full-name (user-real-login-name))

;; files.el --- file input and output commands for Emacs
(use-package files
  :general
  (prefix-def
    "bs" 'save-buffer)
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
  (set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
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
  :commands (dired-dotfiles-toggle
             dired-hide-details-mode
             dired-mark-files-regexp
             dired-do-kill-lines)
  :defines (dired-dotfiles-show-p)
  :general
  (prefix-def
    "md" 'dired-jump
    "mD" 'dired-jump-other-window)
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
  (put 'dired-find-alternate-file 'disabled nil)

  (require 'dired-x)
  (setq dired-guess-shell-alist-user '(("\\.mkv\\'\\|\\.mp4\\'" "mpv"))))

;; whitespace.el --- minor mode to visualize TAB, (HARD) SPACE, NEWLINE
(use-package whitespace
  :diminish
  :hook ((prog-mode text-mode) . whitespace-mode)
  :config (setq whitespace-style '(face trailing tabs tab-mark)))

;; recentf.el --- setup a menu of recently opened files
(use-package recentf
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
    "/gG" 'grep))

;; find-dired.el --- run a `find' command and dired the output
(use-package find-dired
  :general
  (prefix-def
    "fd" 'find-dired
    "fg" 'find-grep-dired))

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

;; find-func.el --- find the definition of the Emacs Lisp function near point
(use-package find-func
  :general
  (prefix-def
    "fl" 'find-library))

;; abbrev.el --- abbrev mode commands for Emacs
(use-package abbrev
  :diminish
  :hook ((text-mode prog-mode) . abbrev-mode)
  :config
  (clear-abbrev-table global-abbrev-table)
  (define-abbrev-table 'global-abbrev-table
  '(("teh" "the"))))

;; xref.el --- Cross-referencing commands
(use-package xref
  :general
  (prefix-def
    "j" '(:ignore t :which-key "jump")
    "j SPC" 'xref-find-definitions
    "jr" 'xref-find-references
    "jo" 'xref-find-definitions-other-window
    "jb" 'xref-pop-marker-stack
    "ja" 'xref-find-apropos))

;; paren.el --- highlight matching paren
(use-package paren :hook (after-init . show-paren-mode))

;; Swiper ======================================================================
;; https://github.com/abo-abo/swiper
;; Ivy - a generic completion frontend for Emacs
(use-package ivy
  :diminish
  :hook (after-init . ivy-mode)
  :general
  (general-def 'normal  'ivy-occur-mode-map
    "<escape>" 'minibuffer-keyboard-quit)
  (prefix-def
    "bb" 'ivy-switch-buffer
    "bB" 'ivy-switch-buffer-other-window)
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

;; Company =====================================================================
;; https://github.com/company-mode/company-mode
;; Modular in-buffer completion framework for Emacs
(use-package company
  :diminish
  :hook ((prog-mode text-mode) . company-mode)
  :functions (company-backend-with-yas)
  :config
  (defun company-backend-with-yas (backends)
    "Add :with company-yasnippet to company BACKENDS."
    (if (and (listp backends) (memq 'company-yasnippet backends))
        backends
      (append (if (consp backends)
                  backends
                (list backends))
              '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-backend-with-yas
                                 '(company-capf
                                   company-files
                                   (company-dabbrev-code company-keywords)
                                   company-dabbrev)))
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 3))

;; https://github.com/joaotavora/yasnippet
;; A template system for Emacs
(use-package yasnippet
  :diminish yas-minor-mode
  :hook ((prog-mode text-mode) . yas-minor-mode)
  :general
  (prefix-def
    "hy" 'yas-describe-tables
    "y" '(:ignore t :which-key "yasnippet")
    "yh" 'yas-describe-tables
    "yn" 'yas-new-snippet
    "yv" 'yas-visit-snippet-file
    "yr" 'yas-reload-all)
  (local-def :keymaps '(snippet-mode-map)
    "l" 'yas-load-snippet-buffer
    "t" 'yas-tryout-snippet
    "c" 'yas-load-snippet-buffer-and-close)
  :custom
  (yas-snippet-dirs '("~/nixos-config/config/snippets"))
  :config
  (yas-reload-all))

;; autoinsert.el --- automatic mode-dependent insertion of text into new files
(use-package autoinsert
  :hook
  ((find-file . auto-insert)
   (after-init . auto-insert-mode))
  :functions (yas-expand-snippet)
  :custom
  (auto-insert-query nil)
  (auto-insert-directory "~/nixos-config/config/templates/")
  :config
  (defun autoinsert-yas-expand ()
    "Replace text in yasnippet template."
    (yas-expand-snippet (buffer-string) (point-min) (point-max)))
  (define-auto-insert "\\.el$" ["elisp.el" autoinsert-yas-expand]))

;; LSP =========================================================================
(use-package lsp-mode
  :hook (((php-mode
           js-mode
           haskell-mode
           haskell-literate-mode
           ) . (lambda ()
           (direnv-update-environment)(lsp))))
  :custom
  (lsp-auto-guess-root nil)
  (lsp-prefer-flymake nil)
  (lsp-file-watch-threshold nil)
  :commands lsp)

(use-package lsp-haskell)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :commands lsp-ui-mode)

;; DAP (Debug Adapter Protocol) ================================================
;; https://github.com/emacs-lsp/dap-mode
;; Emacs heart Debug Adapter Protocol
(use-package dap-mode
  :hook ((php-mode js-mode)  . dap-mode))

(use-package dap-ui
  :hook ((dap-mode . dap-ui-mode)
         (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra/body))))
  :general
  (prefix-def
    "d" '(:ignore t :which-key "debug")
    "d SPC" 'dap-debug
    "dd" 'dap-debug
    "dD" 'dap-debug-edit-template
    "dh" 'dap-hydra/body

    "db" '(:ignore t :which-key "breakpoint")
    "dbt" 'dap-breakpoint-toggle
    "dba" 'dap-breakpoint-add
    "dbd" 'dap-breakpoint-delete
    "dbc" 'dap-breakpoint-condition
    "dbh" 'dap-breakpoint-hit-condition
    "dbl" 'dap-breakpoint-log-message

    "dw" '(:ignore t :which-key "window")
    "dws" 'dap-ui-sessions
    "dwl" 'dap-ui-locals
    "dwe" 'dap-ui-expressions
    "dwb" 'dap-ui-breakpoints
    "dwr" 'dap-ui-repl

    "dsd" 'dap-delete-session
    "dsD" 'dap-delete-all-sessions

    "dq" 'dap-disconnect)
  :config
  (require 'dap-hydra))

(use-package dap-php
  :after (dap-mode)
  :commands (dap-php-setup)
  :functions (dap-register-debug-template)
  :demand t
  :config
  (dap-register-debug-template "Php Ameropa Debug"
                               (list :type "php"
                                     :cwd nil
                                     :request "launch"
                                     :name "PHP FTI Debug"
                                     :stopOnEntry nil
                                     :pathMappings (ht ("/var/www/ameropa"
                                                        "/home/sballert/s7/repos/ameropa/"))
                                     :sourceMaps t))
  (dap-register-debug-template "Php Olimar Debug"
                               (list :type "php"
                                     :cwd nil
                                     :request "launch"
                                     :name "PHP Olimar Debug"
                                     :stopOnEntry nil
                                     :pathMappings (ht ("/var/www/olimar-traffics"
                                                        "/home/sballert/s7/repos/olimar-traffics/"))
                                     :sourceMaps t))
  (dap-register-debug-template "Php FTI Debug"
                               (list :type "php"
                                     :cwd nil
                                     :request "launch"
                                     :name "PHP FTI Debug"
                                     :stopOnEntry nil
                                     :pathMappings (ht ("/var/www/fti-ibe"
                                                        "/home/sballert/s7/repos/fti-ibe/"))
                                     :sourceMaps t)))

(use-package dap-firefox
  :demand t
  :after (dap-mode)
  :commands (dap-firefox-setup))

(use-package dap-node
  :demand t
  :after (dap-mode)
  :commands (dap-node-setup)
  :config
  (dap-register-debug-template "Node::Attach"
                               (list :type "node"
                                     :port 9229
                                     :request "attach"
                                     :protocol "inspector"
                                     :sourceMaps t
                                     :restart t
                                     :name "Node::Attach")))

;; org-mode ====================================================================
;; https://orgmode.org/
;; Org mode is for keeping notes, maintaining TODO lists, planning projects,
;; and authoring documents with a fast and effective plain-text system.
(use-package org
  :demand t
  :general
  (prefix-def
    "o" '(:ignore t :which-key "org")
    "ot" 'org-timer-set-timer)
  (local-def
    :keymaps '(org-mode-map)
    "o" 'org-open-at-point
    "O" 'org-mark-ring-goto
    "b" 'org-babel-demarcate-block
    "t" 'org-babel-tangle
    "e" 'org-export-dispatch
    "l" 'org-insert-link
    "L" 'org-toggle-link-display
    "i" 'org-id-get-create
    "nw" 'widen
    "nb" 'org-narrow-to-block
    "ne" 'org-narrow-to-element
    "ns" 'org-narrow-to-subtree)
  :custom
  (org-confirm-babel-evaluate nil)
  (org-highlight-latex-and-related '(latex script entities))
  (org-startup-folded t)
  (org-clock-sound (concat user-emacs-directory "alarm.wav"))
  (org-timer-default-timer "0:20:00")
  :config
  (let ((languages '(
                     elasticsearch
                     haskell
                     restclient
                     scheme
                     sql
                     )))
    (org-babel-do-load-languages
     'org-babel-load-languages
     (mapcar (lambda (mode) `(,mode . t)) languages)))
  (add-hook 'org-mode-hook 'auto-fill-mode))

;; https://orgmode.org/
;; Dynamic indentation for Org
(use-package org-indent :diminish :hook (org-mode . org-indent-mode))

;; https://github.com/jkitchin/org-ref
;; citations, cross-references and bibliographies in org-mode
(use-package org-ref
  :demand t
  :after (org)
  :general
  (local-def
    :keymaps 'org-mode-map
    "r" 'org-ref-insert-link)
  (:keymaps 'bibtex-mode-map
            "H-b" 'org-ref-bibtex-hydra/body)
  :custom
  (org-ref-insert-link-function 'org-ref-insert-link-hydra/body)
  (org-ref-insert-cite-function 'org-ref-cite-insert-ivy)
  (org-ref-insert-label-function 'org-ref-insert-label-link)
  (org-ref-insert-ref-function 'org-ref-insert-ref-link)
  (org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
  :config
  (require 'ivy-bibtex)
  (require 'org-ref-ivy))

;; https://github.com/sabof/org-bullets
;; utf-8 bullets for org-mode
(use-package org-bullets :hook (org-mode . org-bullets-mode))

;; https://github.com/weirdNox/org-noter
;; A synchronized, Org-mode, document annotator
(use-package org-noter
  :demand t
  :after (org)
  :general
  (local-def
    :keymaps 'org-mode-map
    "N" 'org-noter)
  :custom
  (org-noter-notes-search-path '("~/brain"))
  (org-noter-always-create-frame nil))

;; https://github.com/Somelauw/evil-org-mode
;; Supplemental evil-mode keybindings to emacs org-mode
(use-package evil-org
  :diminish
  :commands (evil-org-set-key-theme)
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (evil-define-key 'motion 'evil-org-mode
    (kbd "0") 'evil-org-beginning-of-line)
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
  :commands (evil-org-agenda-set-keys)
  :after (evil-org)
  :config (evil-org-agenda-set-keys))

;; https://bitbucket.org/eeeickythump/org-drill
;; Self-testing using spaced repetition
(use-package org-drill
  :general
  (local-def
    :keymaps '(org-mode-map)
    "d SPC" 'org-drill
    "dt" 'org-drill-tree
    "dd" 'org-drill-directory
    "dr" 'org-drill-resume)
  :config
  (require 'cl)
  (add-to-list 'org-modules 'org-drill))

;; https://github.com/org-roam/org-roam
;; A database abstraction layer for Org-mode
(use-package org-roam
  :demand t
  :after (org)
  :general
  (prefix-def
    "B" '(:ignore t :which-key "Brain")
    "B SPC" 'org-roam-node-find
    "Bi" 'org-roam-node-insert
    "Ba" 'org-roam-alias-add

    "Bdn" 'org-roam-dailies-capture-today
    "BdY" 'org-roam-dailies-capture-yesterday
    "BdT" 'org-roam-dailies-capture-tomorrow

    "Bdv" 'org-roam-dailies-capture-date
    "Bdc" 'org-roam-dailies-goto-date
    "Bdb" 'org-roam-dailies-goto-previous-note
    "Bdf" 'org-roam-dailies-goto-next-note

    "Bd SPC" 'org-roam-dailies-goto-today
    "Bdy" 'org-roam-dailies-goto-yesterday
    "Bdt" 'org-roam-dailies-goto-tomorrow

    "Bb" 'org-roam-buffer-toggle)
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/brain")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(
     ("d"
      "default"
      plain
      "%?"
      :target (file+head "${slug}.org" "#+title: ${title}")
      :unnarrowed t)
     ("r"
      "bibliography reference"
      plain
      "- tags ::\n- keywords :: %^{keywords}\n\n* %^{title}\n:PROPERTIES:\n:CUSTOM_ID: %^{citekey}\n:URL: %^{url}\n:AUTHOR: %^{author-or-editor}\n:NOTER_DOCUMENT: %^{file}\n:NOTER_PAGE:\n:END:\n"
      :target (file+head "${citekey}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :config
  (org-roam-setup))

;; https://github.com/org-roam/org-roam-bibtex
;; Org Roam meets BibTeX
(use-package org-roam-bibtex
  :diminish
  :demand t
  :after (org-roam)
  :custom
  (orb-preformat-keywords '("citekey" "title" "url" "author-or-editor" "keywords" "file"))
  (orb-process-file-keyword t)
  (orb-file-field-extensions '("pdf"))
  :config
  (require 'org-ref)
  (org-roam-bibtex-mode))

;; Magit =======================================================================
;; https://github.com/magit/magit
;; magit.el --- A Git porcelain inside Emacs
(use-package magit
  :general
  (prefix-def
    "g" '(:ignore t :which-key "magit")
    "g SPC" 'magit-status
    "gb" 'magit-blame
    "gf" 'magit-log-buffer-file))

;; https://github.com/jtatarik/magit-gitflow
;; GitFlow plugin for magit.el
(use-package magit-gitflow
  :after (magit)
  :custom
  (magit-gitflow-popup-key "C-q")
  :hook (magit-mode . turn-on-magit-gitflow))

;; Projectile ==================================================================
;; https://github.com/bbatsov/projectile
;; Project Interaction Library for Emacs
(use-package projectile
  :hook (after-init . projectile-mode)
  :functions (ivy)
  :general
  (prefix-def
    "p" '(:ignore t :which-key "projectile")
    "p SPC" 'projectile-find-file
    "f SPC" 'projectile-find-file

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

    "pb" 'projectile-switch-to-buffer
    "b SPC" 'projectile-switch-to-buffer)
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
  ;;(prefix-def
  ;;  "N" '(:ignore t :which-key "nix")
  ;;  "Nb" 'nix-build
  ;;  "NR" 'nix-repl
  ;;  "Ns" 'nix-shell
  ;;  "Nu" 'nix-unpack)
  :config (setq nix-indent-function 'nix-indent-line))

;; https://github.com/purcell/emacs-nixpkgs-fmt
;; Reformat Nix using nixpkgs-fmt
(use-package nixpkgs-fmt
  :diminish
  :hook (nix-mode . nixpkgs-fmt-on-save-mode)
  :general
  (local-def
    :keymaps '(nix-mode-map)
    "fb" 'nixpkgs-fmt-buffer
    "fr" 'nixpkgs-fmt-region))

;; https://github.com/NixOS/nix-mode
;; nix-drv-mode.el --- Major mode for viewing .drv files
(use-package nix-drv-mode :mode "\\.drv\\'")

;; Misc ========================================================================
;; https://github.com/flycheck/flycheck
;; On the fly syntax checking for GNU Emacs
(use-package flycheck
  :diminish
  :hook
  ((after-init) . global-flycheck-mode)
  :custom
  (flycheck-checker-error-threshold 1000)
  :config
  (prefix-def
    "c" '(:ignore t :which-key "flycheck")
    "c SPC" 'flycheck-list-errors
    "cl" 'flycheck-list-errors
    "cc" 'flycheck-buffer
    "cC" 'flycheck-clear
    "cp" 'flycheck-previous-error
    "cv" 'flycheck-verify-setup
    "cn" 'flycheck-next-error))

;; https://github.com/wbolster/emacs-direnv
;; direnv integration for emacs
(use-package direnv
  :diminish
  :hook
  ((after-init . direnv-mode)
   (flycheck-before-syntax-check . direnv-update-environment))
  :config
  (add-to-list 'warning-suppress-types '(direnv))
  (setq direnv-always-show-summary nil))

;; https://github.com/bbatsov/super-save
;; Save Emacs buffers when they lose focus
(use-package super-save
  :diminish
  :hook (after-init . super-save-mode)
  :custom
  (super-save-triggers '(switch-to-buffer
                         other-window
                         windmove-up
                         windmove-down
                         windmove-left
                         windmove-right
                         next-buffer
                         previous-buffer
                         kill-current-buffer
                         magit-status
                         ansi-term))
  (super-save-auto-save-when-idle t))

;; https://github.com/lewang/ws-butler
;; Unobtrusively trim extraneous white-space *ONLY* in lines edited.
(use-package ws-butler :diminish :hook (after-init . ws-butler-global-mode))

;; https://github.com/alpaker/Fill-Column-Indicator
;; An Emacs minor mode that graphically indicates the fill column.
(use-package fill-column-indicator
  :disabled
  :hook (prog-mode . fci-mode)
  :config
  (setq fci-rule-width 1
        fci-rule-column 80
        fci-rule-color "#665c54"))

;; https://github.com/wasamasa/shackle
;; Enforce rules for popup windows
(use-package shackle
  :hook (after-init . shackle-mode)
  :commands (shackle--splittable-frame)
  :functions (shackle--smart-split-dir
              org-src-switch-to-buffer
              shackle-org-src-pop-to-buffer)
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
          (window--display-buffer buffer window 'window alist )
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
                             :height 1.5))
  (add-hook 'nov-mode-hook 'my-nov-font-setup))

;; https://github.com/Fanael/rainbow-delimiters
;; Emacs rainbow delimiters mode
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))

;; https://github.com/Malabarba/aggressive-indent-mode
;; aggressive-indent.el --- Minor mode to aggressively keep your code always indented
(use-package aggressive-indent
  :hook
  ((emacs-lisp-mode) . aggressive-indent-mode)
  :defines (aggressive-indent-protected-commands)
  :general
  (prefix-def "ma" 'aggressive-indent-mode)
  :custom
  (aggressive-indent-comments-too nil)
  :config
  (dolist (command '(next-line previous-line))
    (add-to-list 'aggressive-indent-protected-commands command)))

;; PDF Tools ===================================================================
;; https://github.com/politza/pdf-tools
;; Emacs support library for PDF files.
(use-package pdf-tools
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :functions (pdf-tools-disable-cursor
              pdf-tools-advice-evil-refresh-cursor)
  :commands (pdf-isearch-minor-mode
             pdf-view-midnight-minor-mode)
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

;; auctex ======================================================================
;; https://www.gnu.org/software/auctex/
;; AUCTeX is an extensible package for writing and formatting TeX files in GNU Emacs.
(use-package tex-site
  :demand t
  :after (tex-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  (TeX-PDF-mode t))

(use-package tex-mode
  :general
  (local-def
    :keymaps '(LaTeX-mode-map)
    "a" 'TeX-command-run-all
    "c" 'TeX-command-master)
  :mode ("\\.tex\\'" . latex-mode))

;; bibtex ======================================================================
;; bibtex.el --- BibTeX mode for GNU Emacs
(use-package bibtex :mode ("\\.bib\\'" . bibtex-mode))

;; https://github.com/tmalsburg/helm-bibtex
;; A bibliography manager based on Ivy
(use-package ivy-bibtex
  :after (ivy)
  :general
  (prefix-def
    "fb" 'ivy-bibtex)
  :custom
  (bibtex-completion-notes-path "~/library/notes.org")
  (bibtex-completion-library-path '("~/library"))
  (bibtex-completion-bibliography '("~/library/bibliography.bib"))
  (bibtex-completion-notes-template-multiple-files
   "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n")
  (bibtex-completion-additional-search-fields '(keywords))
  (bibtex-completion-display-formats
   '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
     (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
     (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
     (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
     (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}")))
  (bibtex-autokey-year-length 4)
  (bibtex-autokey-name-year-separator "-")
  (bibtex-autokey-year-title-separator "-")
  (bibtex-autokey-titleword-separator "-")
  (bibtex-autokey-titlewords 2)
  (bibtex-autokey-titlewords-stretch 1)
  (bibtex-autokey-titleword-length 5))

;; dictcc ======================================================================
;; https://github.com/martenlienen/dictcc.el
;; An interface to look up translations on dict.cc without leaving emacs.
(use-package dictcc
  :general
  (prefix-def
    "ml SPC" 'dictcc
    "ml p" 'dictcc-at-point))

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
    "Pr" 'password-store-rename
    "Pu" 'password-store-url
    "PC" 'password-store-clear
    "PG" 'password-store-generate
    "PI" 'password-store-init
    "Pc" 'password-store-copy)
  :config
  (setq password-store-password-length 30))

;; Lispy Languages =============================================================

;; https://github.com/abo-abo/lispy
;; lispy.el --- vi-like Paredit.
(use-package lispy
  :diminish
  :hook
  ((emacs-lisp-mode) . lispy-mode)
  :after (ivy)
  :custom
  (lispy-completion-method #'ivy)
  :general
  (:states 'insert :keymaps '(emacs-lisp-mode-map lisp-interaction-mode-map)
           "(" #'lispy-parens
           "[" #'lispy-brackets
           "{" #'lispy-braces
           "\"" #'lispy-quotes))

;; https://github.com/noctuid/lispyville
;; lispyville.el --- A minor mode for integrating evil with lispy.
(use-package lispyville
  :diminish
  :hook (lispy-mode . lispyville-mode)
  :commands (lispyville-set-key-theme)
  :config
  (lispyville-set-key-theme
   '(operators
     c-w
     prettify
     text-objects
     slurp/barf-cp
     (escape insert)
     (additional-movement normal visual motion))))

;; elisp-mode.el --- Emacs Lisp mode
(use-package elisp-mode
  :general
  (local-def
    :keymaps '(emacs-lisp-mode-map lisp-interaction-mode-map)
    "b" 'eval-buffer
    "d" 'toggle-debug-on-error
    "f" 'debug-on-entry
    "F" 'cancel-debug-on-entry
    "l" 'eval-last-sexp
    "e" 'eval-defun))

;; pp.el --- pretty printer for Emacs Lisp
(use-package pp
  :general
  (prefix-def
    ";" 'pp-eval-expression)
  (local-def
    :keymaps '(emacs-lisp-mode-map lisp-interaction-mode-map)
    "p" 'pp-eval-last-sexp))

;; C/C++ =======================================================================
;;; cc-mode.el --- major mode for editing C and similar languages
(use-package cc-mode
  :mode (("\\.c$". c-mode)
         ("\\.h$" . c-mode)))

;; https://github.com/llvm-mirror/clang/blob/master/tools/clang-format/clang-format.el
;; Format code using clang-format
(use-package clang-format
  :hook (cc-mode . (lambda ()
                     (require 'clang-format))))

;; https://github.com/SavchenkoValeriy/emacs-clang-format-plus
;; Minor mode for automatic clang-format application
(use-package clang-format+
  :diminish
  :hook (c-mode-common . clang-format+-mode))

;; PHP =========================================================================
;; https://github.com/emacs-php/php-mode
;; A PHP mode for GNU Emacs
(use-package php-mode :mode ("\\.php$" . php-mode))

;; HTML ========================================================================
;; https://github.com/fxbois/web-mode
;; major mode for editing web templates
(use-package web-mode
  :mode("\\.twig$" "\\.html?$")
  :config
  (setq web-mode-script-padding 4))

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
  :custom
  (haskell-indentation-layout-offset 4)
  (haskell-indentation-starter-offset 4)
  (haskell-indentation-left-offset 4)
  (haskell-indentation-where-pre-offset 4)
  (haskell-indentation-where-post-offset 4)
  :mode ("\\.hs$" . haskell-mode))

(use-package haskell-interactive-mode
  :diminish
  :hook (haskell-mode . interactive-haskell-mode)
  :general
  (local-def
    :keymaps '(haskell-mode-map)
    "r" 'run-haskell)
  :custom
  (haskell-process-suggest-remove-import-lines t)
  (haskell-process-auto-import-loaded-modules t)
  (haskell-process-log t))

;; JavaScript ==================================================================
;; js.el --- Major mode for editing JavaScript
(use-package js
  :mode(("\\.js$". js-mode) ("\\.jsx$" . js-mode))
  :general
  (local-def
    :keymaps '(js-mode-map)
    "r" 'nodejs-repl
    "ce" 'nodejs-repl-send-last-expression
    "cj" 'nodejs-repl-send-line
    "cr" 'nodejs-repl-send-region
    "cc" 'nodejs-repl-send-buffer
    "cl" 'nodejs-repl-load-file
    "cz" 'nodejs-repl-switch-to-repl)
  :config
  ;; https://github.com/abicky/nodejs-repl.el
  ;; Run Node.js REPL in Emacs
  (require 'nodejs-repl))

;; https://github.com/mooz/js2-mode
;; Improved JavaScript editing mode for GNU Emacs
(use-package js2-mode
  :diminish
  :hook (js-mode . js2-minor-mode)
  :custom
  (js2-mode-show-parse-errors nil)
  (js2-mode-show-strict-warnings nil)
  (js2-strict-missing-semi-warning nil)
  :config
  (diminish 'js2-minor-mode))

;; https://github.com/jscheid/prettier.el
;; Reformats your code by running Prettier on file save or on request
(use-package prettier
  :diminish
  :disabled
  :hook (js-mode . (lambda ()
                     (direnv-update-environment)
                     (when (executable-find "prettier")(prettier-mode)))))

;; JSON ========================================================================
;; https://github.com/joshwnj/json-mode
;; Major mode for editing JSON files with emacs
(use-package json-mode
  :general
  (local-def
    :keymaps '(json-mode-map)
    "f" 'evil-json-pretty-print)
  :commands (evil-json-reformat)
  :after (evil)
  :functions (evil-has-command-property-p
              evil-get-command-property
              evil-operator-range
              evil-visual-state-p
              evil-visual-rotate
              evil-set-command-properties
              json-pretty-print)
  :config
  (evil-define-operator evil-json-pretty-print (beg end)
    "Indent text."
    :move-point nil
    :type line
    (goto-char beg)
    (json-pretty-print beg end))
  :mode("\\.json$"))

;; Markdown ====================================================================
;; https://github.com/jrblevin/markdown-mode
;; markdown-mode.el --- Major mode for Markdown-formatted text
(use-package markdown-mode :mode ("\\.\\(m\\(ark\\)?down\\|md\\)$" . markdown-mode))

;; YAML ========================================================================
;; https://github.com/yoshiki/yaml-mode
;; The emacs major mode for editing files in the YAML data serialization format.
(use-package yaml-mode
  :mode ("\\.\\(\\yml\\|yaml\\)$" . yaml-mode))

;; Elasticsearch
;; https://github.com/dakrone/es-mode
;; A major mode for editing and executing Elasticsearch queries
(use-package es-mode :mode ("\\.es$" . es-mode))

;; Kotlin
;; https://github.com/Emacs-Kotlin-Mode-Maintainers/kotlin-mode
;; Major mode for kotlin
(use-package es-mode :mode ("\\.kt$" . kotlin-mode))

;; Scheme =================+++===================================================
;; https://www.nongnu.org/geiser/
;; GNU Emacs and Scheme talk to each other
(use-package geiser
  :hook (scheme-mode . (lambda ()
                         (direnv-update-environment)
                         (require 'geiser-guile)
                         (setq geiser-active-implementations '(guile))
                         (geiser-mode))))

;; Tools ========================================================================
;; https://github.com/pashky/restclient.el
;; HTTP REST client tool for emacs
(use-package restclient :mode ("\\.rest$" . restclient-mode))

;; Theme =======================================================================
(require 'gruvbox)
(load-theme 'gruvbox t)

;; Finalize ====================================================================
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)

;;; init.el ends here
