;;; init-navigation.el --- Navegação -*- lexical-binding: t; -*-

(with-eval-after-load 'info
  (define-key Info-mode-map (kbd ",") #'Info-search-next))

(defun my/other-window-backward ()
  "Vai para a janela anterior."
  (interactive)
  (other-window -1))

;; atalho para voltar para janela anterior
;; (global-set-key (kbd "C-x w p") #'my/other-window-backward)
(global-set-key (kbd "C-c n") #'other-window)
(global-set-key (kbd "C-c p") #'my/other-window-backward)

(provide 'init-navigation)
;;; init-navigation.el ends here
