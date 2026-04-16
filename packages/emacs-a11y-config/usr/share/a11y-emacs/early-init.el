;;; early-init.el --- Configuração inicial do Emacs A11y
;;;
;;; Arquivo carregado antes de init.el
;;; Use para configurações que precisam de aplicação precoce
;;;

;; Desabilita elementos de GUI não necessários para acessibilidade
(setq default-frame-alist
      '((fullscreen . maximized)
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)))

;; Melhora responsividade de leitura de tela
(setq jit-lock-defer-time 0.05)
(setq font-lock-support-mode 'jit-lock-mode)

;; Configuração básica de encoding
(set-language-environment 'UTF-8)
(set-default-coding-systems 'utf-8)
