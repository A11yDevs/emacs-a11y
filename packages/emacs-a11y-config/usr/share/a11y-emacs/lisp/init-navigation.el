;;; init-navigation.el --- Configurações de navegação aprimorada
;;;
;;; Melhorias para navegação eficiente no editor

(provide 'init-navigation)

;; Atalhos de navegação melhorados
(global-set-key (kbd "C-c n") 'next-line)
(global-set-key (kbd "C-c p") 'previous-line)
(global-set-key (kbd "C-c f") 'forward-char)
(global-set-key (kbd "C-c b") 'backward-char)

;; Navegação por word boundary
(global-set-key (kbd "C-c M-f") 'forward-word)
(global-set-key (kbd "C-c M-b") 'backward-word)

;; Início e fim de linha
(global-set-key (kbd "C-c a") 'beginning-of-line)
(global-set-key (kbd "C-c e") 'end-of-line)

;; Pula entre secciones
(global-set-key (kbd "C-c [") 'backward-paragraph)
(global-set-key (kbd "C-c ]") 'forward-paragraph)
