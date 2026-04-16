;; init.el --- Configuração modular do Emacs -*- lexical-binding: t; -*-

;; remover a tela inicial de bem-vindo
(setq inhibit-startup-message t)

;; desativa o menu
(menu-bar-mode -1)

;; exibe numeração de linhas
(global-display-line-numbers-mode t)

;; exibe destaque de linha
(global-hl-line-mode t)

;; Diretório de módulos
(setq a11y-emacs-lib-dir (file-name-directory load-file-name))
(add-to-list 'load-path (expand-file-name "lisp" a11y-emacs-lib-dir))

;; Mantém customizações automáticas separadas do código manual.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

(require 'init-packages)       ;; repo de pacotes
(require 'init-accessibility)  ;; acessibilidade
(require 'init-core)           ;; básicas
(require 'init-dired)          ;; explorador de arquivos
(require 'init-completion)     ;; auto-complete de código
(require 'init-java)           ;; java básico: compilar, executar, etc
(require 'init-java-lsp)       ;; java avançado: sintaxe, docs
(require 'init-gptel)          ;; suporte ao gpt e outros
(require 'init-shell)          ;; shell: formato do prompt
(require 'init-layout)         ;; redimensiona janelas
(require 'init-activities)     ;; salva sessões
(require 'init-navigation)     ;; atalhos janela anterior e seguinte
(require 'init-layout-ide)     ;; layout de janelas semelhante a uma IDE

;; Carrega customizações do usuário, se existirem
(let ((user-init-file (expand-file-name "~/.config/a11y-emacs/user-init.el")))
  (when (file-exists-p user-init-file)
    (load-file user-init-file)))

(message "Emacs A11y inicializado com sucesso!")
;;; init.el ends here
