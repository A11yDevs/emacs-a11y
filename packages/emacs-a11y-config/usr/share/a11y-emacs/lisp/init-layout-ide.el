;;; init-layout-ide.el --- Layout genérico de IDE -*- lexical-binding: t; -*-

(defgroup my/layout-ide nil
  "Configurações do layout genérico de IDE."
  :group 'convenience)

(defcustom my/layout-ide-sidebar-width 0.2
  "Proporção da largura da barra lateral esquerda."
  :type 'float
  :group 'my/layout-ide)

(defcustom my/layout-ide-bottom-height 0.2
  "Proporção da altura da janela inferior."
  :type 'float
  :group 'my/layout-ide)

(defcustom my/layout-ide-default-directory "~/"
  "Diretório padrão aberto no Dired ao montar o layout."
  :type 'directory
  :group 'my/layout-ide)

(defcustom my/layout-ide-main-buffer-name "*ide*"
  "Nome do buffer principal de edição criado pelo layout."
  :type 'string
  :group 'my/layout-ide)

(defcustom my/layout-ide-terminal-function #'shell
  "Função usada para abrir o terminal na janela inferior."
  :type 'function
  :group 'my/layout-ide)

(defun my/layout-ide--safe-ratio (value fallback)
  "Retorna VALUE se estiver entre 0.1 e 0.9; caso contrário, FALLBACK."
  (if (and (numberp value) (> value 0.1) (< value 0.9))
      value
    fallback))

(defun my/layout-ide ()
  "Monta um layout genérico de IDE no frame atual.

Layout:
- inferior: terminal com cerca de 20% da altura
- superior esquerda: Dired com cerca de 20% da largura
- superior direita: buffer principal de edição"
  (interactive)
  (delete-other-windows)

  (let* ((sidebar-ratio (my/layout-ide--safe-ratio my/layout-ide-sidebar-width 0.2))
         (bottom-ratio (my/layout-ide--safe-ratio my/layout-ide-bottom-height 0.2))
         (top (selected-window))
         (bottom-size (floor (* (- 1 bottom-ratio) (window-total-height top))))
         (bottom (split-window top bottom-size 'below))
         left
         right)

    ;; Divide a parte superior em lateral esquerda e área principal.
    (select-window top)
    (setq right (split-window top (floor (* sidebar-ratio (window-total-width top))) 'right))
    (setq left top)

    ;; Barra lateral: Dired
    (select-window left)
    (let ((default-directory (file-name-as-directory
                              (expand-file-name my/layout-ide-default-directory))))
      (dired default-directory))

    ;; Área principal: buffer de edição
    (select-window right)
    (switch-to-buffer (get-buffer-create my/layout-ide-main-buffer-name))
    (fundamental-mode)

    ;; Parte inferior: terminal
    (select-window bottom)
    (condition-case err
        (funcall my/layout-ide-terminal-function)
      (error
       (message "Erro ao abrir terminal com %s: %s"
                my/layout-ide-terminal-function
                (error-message-string err))
       (switch-to-buffer (get-buffer-create "*terminal*"))))

    ;; Volta para a área principal
    (select-window right)))

(defun my/layout-ide-at-directory (dir)
  "Monta o layout genérico de IDE usando DIR no Dired."
  (interactive "DDiretório do projeto: ")
  (let ((my/layout-ide-default-directory
         (file-name-as-directory (expand-file-name dir))))
    (my/layout-ide)))

(provide 'init-layout-ide)
;;; init-layout-ide.el ends here
