(provide 'seancoding)

(use-package flycheck
  :ensure t)

(use-package eglot
  :ensure t)

(use-package rustic
  :ensure t
  :init (setq rustic-lsp-client 'eglot
              rustic-analyzer-command '("~/.cargo/bin/rust-analyzer")))

(add-hook 'prog-mode-hook
          (lambda ()
            (linum-mode)
            (hs-minor-mode)
            (subword-mode)))
