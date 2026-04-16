;;; init.el --- Configuração principal do Emacs A11y
;;;
;;; Ponto de entrada para a configuração acessível do Emacs
;;; para pessoas com deficiência visual.
;;;

;; Carrega arquivos de configuração específicos
(setq a11y-emacs-lib-dir (file-name-directory load-file-name))

;; Adiciona diretório de lisp ao load-path
(add-to-list 'load-path (concat a11y-emacs-lib-dir "lisp"))

;; Carrega configurações principais
(require 'init-core nil t)
(require 'init-accessibility nil t)
(require 'init-navigation nil t)

;; Carrega customizações do usuário, se existirem
(let ((user-init-file (expand-file-name "~/.config/a11y-emacs/user-init.el")))
  (when (file-exists-p user-init-file)
    (load-file user-init-file)))

(message "Emacs A11y inicializado com sucesso!")
