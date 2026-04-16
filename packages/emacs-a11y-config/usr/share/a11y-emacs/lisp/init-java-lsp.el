;;; init-java-lsp.el --- LSP para Java -*- lexical-binding: t; -*-

(when (and (my/package-installed-or-warn 'lsp-mode)
           (my/package-installed-or-warn 'lsp-java))
  (require 'lsp-mode)
  (require 'lsp-java)
  (require 'project)

  (setq lsp-prefer-flymake nil)
  (setq lsp-eldoc-enable-hover nil)
  (setq lsp-log-io nil)

  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-disabled-clients 'semgrep-ls))

  ;; Só aplica se lsp-ui existir e for carregado
  (with-eval-after-load 'lsp-ui
    (setq lsp-ui-doc-enable nil)
    (setq lsp-ui-sideline-enable nil))

  (defun my-java-maybe-start-lsp ()
    "Inicia LSP para Java apenas quando estiver em um projeto."
    (when (and buffer-file-name
               (project-current nil))
      (lsp-deferred)))

  (add-hook 'java-mode-hook #'my-java-maybe-start-lsp)
  (add-hook 'java-ts-mode-hook #'my-java-maybe-start-lsp))

(provide 'init-java-lsp)
;;; init-java-lsp.el ends here
