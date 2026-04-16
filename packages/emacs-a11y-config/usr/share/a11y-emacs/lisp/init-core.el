;;; init-core.el --- Configurações gerais -*- lexical-binding: t; -*-

(savehist-mode 1)
(fido-mode 1)
(global-hl-line-mode 1)
(column-number-mode 1)
(line-number-mode 1)
(setq line-move-visual nil)

;; scratch limpo
(setq initial-scratch-message nil)
(setq initial-major-mode 'text-mode)

;; comportamento inteligente com activities
(defun my/open-empty-buffer-if-no-activity ()
  "Abre um buffer vazio se não houver atividades ativas."
  (unless (and (boundp 'activities-current)
               activities-current)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (erase-buffer)
    (funcall initial-major-mode)))

(add-hook 'emacs-startup-hook #'my/open-empty-buffer-if-no-activity)

(provide 'init-core)
;;; init-core.el ends here
