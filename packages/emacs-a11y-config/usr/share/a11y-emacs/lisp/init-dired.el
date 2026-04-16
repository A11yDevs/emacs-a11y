;;; init-dired.el --- Dired -*- lexical-binding: t; -*-

;; Dired mais enxuto
(setq dired-listing-switches "-ahl")

;; Oculta detalhes extras por padrão
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Atualiza automaticamente ao reutilizar buffer do dired
(setq dired-kill-when-opening-new-dired-buffer t)

;; Reverte buffers do dired automaticamente quando o diretório muda
(add-hook 'dired-mode-hook #'auto-revert-mode)

;; Atalho para alternar detalhes visíveis/ocultos
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "(") #'dired-hide-details-mode))

(defun my-dired-sidebar-here ()
  "Abre o Dired na esquerda e preserva arquivos na direita."
  (interactive)
  (let ((dir default-directory))
    (delete-other-windows)
    (dired dir)
    (split-window-right)
    (other-window 1)))

(defun my-dired-open-in-side-layout ()
  "No Dired, abre arquivo na janela da direita."
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (unless (window-in-direction 'right)
      (split-window-right))
    (other-window 1)
    (find-file file)
    (other-window -1)))

(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "o") #'my-dired-open-in-side-layout))

(provide 'init-dired)
;;; init-dired.el ends here
