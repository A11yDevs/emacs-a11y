;;; init.el --- Inicialização do Emacs para novos usuários com a11y-emacs
;;;
;;; Este arquivo é provisionado em /etc/skel e será copiado para
;;; ~/.emacs.d/init.el para novos usuários.
;;;
;;; Não modifica configuração existente de usuários já presentes no sistema.

;; Carrega função de pauperização mínima
(setq package-enable-at-startup nil)

;; Verifica se a configuração a11y-emacs está disponível
(let ((a11y-init "/usr/share/a11y-emacs/init.el"))
  (if (file-exists-p a11y-init)
      (progn
        (message "Carregando configuração a11y-emacs...")
        (load-file a11y-init))
    (message "Aviso: Configuração a11y-emacs não encontrada em %s" a11y-init)))

;; Espaço para customizações pessoais do usuário
(when (version< emacs-version "27.0")
  (load custom-file 'noerror))
