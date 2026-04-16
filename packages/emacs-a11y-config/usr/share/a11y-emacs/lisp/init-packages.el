;;; init-packages.el --- Pacotes e repositórios -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(defun my/package-installed-or-warn (pkg)
  "Verifica se PKG está instalado.
Se não estiver, mostra mensagem amigável e retorna nil.
Se estiver, retorna t."
  (if (package-installed-p pkg)
      t
    (progn
      (message "Pacote '%s' não instalado. Use M-x my/install-package para instalar." pkg)
      nil)))

;; opcional: manter seu instalador manual
(defun my/install-package (pkg)
  "Instala manualmente um pacote PKG."
  (interactive "SPacote a instalar: ")
  (unless package-archive-contents
    (package-refresh-contents))
  (if (package-installed-p pkg)
      (message "Pacote '%s' já está instalado." pkg)
    (progn
      (message "Instalando pacote '%s'..." pkg)
      (package-install pkg)
      (message "Pacote '%s' instalado com sucesso." pkg))))

(provide 'init-packages)
;;; init-packages.el ends here
