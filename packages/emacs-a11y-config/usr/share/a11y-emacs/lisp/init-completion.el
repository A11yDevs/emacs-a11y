;;; init-completion.el --- Autocompletar -*- lexical-binding: t; -*-

(when (my/package-installed-or-warn 'company)
  (require 'company)

  (setq company-idle-delay nil)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-show-quick-access nil)

  (add-hook 'after-init-hook #'global-company-mode)
  (global-set-key (kbd "M-/") #'company-complete)

  (with-eval-after-load 'company
    (define-key company-active-map (kbd "C-n") #'company-select-next)
    (define-key company-active-map (kbd "C-p") #'company-select-previous)
    (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
    (define-key company-active-map (kbd "TAB") #'company-complete-selection)
    (define-key company-active-map (kbd "RET") #'company-complete-selection)))

(provide 'init-completion)
