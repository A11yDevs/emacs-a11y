;;; init-accessibility.el --- Configurações de acessibilidade
;;;
;;; Suporte aprimorado para leitores de tela e tecnologias assistivas

(provide 'init-accessibility)

;; Modo de linha visível (melhora feedback visual/auditivo)
(setq-default visual-line-mode t)

;; Verbosidade aumentada para feedback de leitor de tela
(setq ring-bell-function 'ignore)
(setq visible-bell nil)

;; Melhor cursor para detectabilidade
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.5)

;; Mensagens mais claras
(setq echo-keystrokes 0.1)
(setq suggest-key-bindings 5)

;; Suporte a navegação por página
(global-set-key [remap scroll-down-command] 'scroll-down-command)
(global-set-key [remap scroll-up-command] 'scroll-up-command)
