;;; init-core.el --- Configurações principais e globais
;;;
;;; Define comportamentos básicos do editor

(provide 'init-core)

;; Interface básica
(menu-bar-mode 1)
(tool-bar-mode -1)
(column-number-mode 1)
(size-indication-mode 1)

;; Comportamento de edição
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(global-auto-revert-mode 1)
(setq auto-revert-interval 2)

;; Regiões da tela
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Comportamento de backup
(setq backup-inhibited t)
(setq auto-save-default nil)
