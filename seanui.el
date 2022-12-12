(provide 'seanui)

;; Builtings
(show-paren-mode t)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

(setq-default inhibit-scratch-message nil
              initial-scratch-message ""
              indent-tabs-mode nil
              tab-width 4
              tab-always-indent 'complete
              fill-column 120)

(setq inhibit-startup-message t
      inhibit-startup-screen t
      ring-bell-function 'ignore
      visible-bell t
      inhibit-startup-echo-area-message t
      backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      scroll-step 1
      mouse-wheel-follow-mouse 't
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(1 ((shift) . 1)))

(electric-indent-mode t)
(electric-pair-mode t)
(electric-layout-mode t)
(global-hl-line-mode t)

(set-face-attribute 'default nil :height 160)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'cl-lib)
(require 'color)

(use-package sublime-themes
  :ensure t
  :config (load-theme 'spolsky t))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face
          (intern
           (format "rainbow-delimiters-depth-%d-face" index))))
     (cl-callf color-saturate-name (face-foreground face) 30)))
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground 'unspecified
                      :inherit 'error
                      :strike-through t))

(use-package drag-stuff
  :ensure t
  :config (drag-stuff-mode t))

(use-package powerline
  :ensure t
  :config (powerline-default-theme))

(use-package fill-column-indicator
  :ensure t)

(use-package projectile
  :ensure t
  :init   (setq projectile-use-git-grep t)
  :config (projectile-global-mode t)
  :bind   (("C-c f" . projectile-find-file)
           ("C-c C-f" . projectile-grep)))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :init (setq undo-tree-auto-save-history 0)
  :config (global-undo-tree-mode)
  :bind ("C-?" . undo-tree-visualize))

(use-package flx-ido
  :ensure t
  :demand
  :init (setq ido-enable-flex-matching t
              ido-show-dot-for-dired nil
              ido-enable-dot-prefix t)
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1))

(use-package highlight-symbol
  :ensure t
  :diminish highlight-symbol-mode
  :bind ("C-c h" . highlight-symbol))

;; Go to last change after moving around (i.e. while reading bad code)
(use-package goto-chg
  :ensure t
  ;; complementary to
  ;; C-x r m / C-x r l
  ;; and C-<space> C-<space> / C-u C-<space>
  :bind (("C-." . goto-last-change)
         ("C-," . goto-last-change-reverse)))

(use-package magit
  :ensure t
  :init (setq magit-revert-buffers nil
              magit-auto-revert-mode nil
              magit-last-seen-setup-instruction "1.4.0")
  :bind (("C-c C-g s" . magit-status)
         ("C-c C-g b" . magit-blame)))

(use-package company
  :ensure t
  :diminish company-mode company-capf
  :init (setq company-dabbrev-ignore-case nil
              company-dabbrev-code-ignore-case nil
              company-dabbrev-downcase nil
              company-idle-delay 0.2
              company-minimum-prefix-length 1)
  :config (global-company-mode))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :init (setq yas-verbosity 0)
  :config
  (use-package yasnippet-snippets
    :ensure t)
  (yas-reload-all)
  (yas-global-mode t))

;; I don't even remember what this is for
(use-package etags-select
  :commands etags-select-find-tag)

(use-package ace-jump-mode
  :ensure t
  :commands ace-jump-mode
  :init (define-key global-map (kbd "C-c SPC") 'ace-jump-mode))

;; Very helpful customization of killing backwards
(defun contextual-backspace ()
  "Hungry whitespace or delete work depending on context."
  (interactive)
  (if (looking-back "[[:space:]\n]\\{2,\\}" (- (point) 2))
      (while (looking-back "[[:space:]\n]" (- (point) 1))
        (delete-char -1))
    (cond
     ((and (boundp 'smart-parens-strict-mode)
           smartparens-strict-mode)
      (sp-backward-kill-work 1))
     ((and (boundp 'subword-mode)
           subword-mode)
      (subword-backward-kill 1))
     (t
      (backward-kill-word 1)))))

(global-set-key (kbd "C-<backspace>") 'contextual-backspace)
