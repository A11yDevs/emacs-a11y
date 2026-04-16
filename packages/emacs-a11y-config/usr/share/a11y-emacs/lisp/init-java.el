;;; init-java.el --- Compilação e execução Java -*- lexical-binding: t; -*-

(require 'project)
(require 'cc-mode)
(require 'comint)
(require 'compile)

(defvar-local my-java-run-command nil
  "Comando java a ser executado após compilação bem-sucedida.")

(defun my-java--buffer-package-name ()
  "Retorna o package declarado no buffer atual, ou nil."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward
           "^[[:space:]]*package[[:space:]]+\\([A-Za-z0-9_.]+\\)[[:space:]]*;"
           nil t)
      (match-string-no-properties 1))))

(defun my-java--main-class-name (file package)
  "Retorna o nome qualificado da classe principal."
  (let ((class (file-name-base file)))
    (if (and package (not (string-empty-p package)))
        (concat package "." class)
      class)))

(defun my-java--build-dir (file)
  "Retorna o diretório de build usado para compilar classes Java."
  (expand-file-name ".emacs-java-build"
                    (file-name-directory (expand-file-name file))))

(defun my-java--interactive-buffer-name ()
  "*Java Run*")

(defun my-java--speak-buffer-if-available (buffer)
  "Vocaliza BUFFER quando possível."
  (when (buffer-live-p buffer)
    (with-current-buffer buffer
      (goto-char (point-min))
      (when (fboundp 'emacspeak-speak-buffer)
        (emacspeak-speak-buffer)))))

(defun my-java--prepare-run-buffer ()
  "Cria e prepara um buffer limpo para entrada e saída do programa."
  (let ((buf (get-buffer-create (my-java--interactive-buffer-name))))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer)
      (shell-mode)
      (goto-char (point-max)))
    buf))

(defun my-java--start-interactive-run (cmd)
  "Executa CMD em um shell interativo limpo."
  (let ((buf (my-java--prepare-run-buffer)))
    (pop-to-buffer buf)
    (goto-char (point-max))
    (let ((proc (get-buffer-process buf)))
      (unless (and proc (process-live-p proc))
        (shell buf)
        (setq proc (get-buffer-process buf)))
      (goto-char (point-max))
      (comint-clear-buffer)
      (goto-char (point-max))
      (process-send-string proc (concat cmd "\n"))
      (message "Programa Java em execução.")
      (when (fboundp 'emacspeak-auditory-icon)
        (emacspeak-auditory-icon 'select-object)))))

(defun my-java--compilation-finish (buffer status)
  "Se compilou com sucesso, executa a classe associada em buffer interativo."
  (when (buffer-live-p buffer)
    (with-current-buffer buffer
      (if (and my-java-run-command
               (string-match "finished" status))
          (my-java--start-interactive-run my-java-run-command)
        (progn
          (pop-to-buffer buffer)
          (goto-char (point-min))
          (when (fboundp 'emacspeak-auditory-icon)
            (emacspeak-auditory-icon 'warn-user))
          (my-java--speak-buffer-if-available buffer))))))

(add-hook 'compilation-finish-functions #'my-java--compilation-finish)

(defun run-java ()
  "Compila e executa a classe Java atual."
  (interactive)
  (if-let ((file (buffer-file-name)))
      (let* ((package (my-java--buffer-package-name))
             (main-class (my-java--main-class-name file package))
             (build-dir (my-java--build-dir file))
             (compile-cmd (format "mkdir -p %s && javac -d %s %s"
                                  (shell-quote-argument build-dir)
                                  (shell-quote-argument build-dir)
                                  (shell-quote-argument file)))
             (run-cmd (format "java -cp %s %s"
                              (shell-quote-argument build-dir)
                              main-class))
             (buf (compilation-start
                   compile-cmd
                   'compilation-mode
                   (lambda (_) "*Java Compile*"))))
        (with-current-buffer buf
          (setq-local my-java-run-command run-cmd))
        (message "Compilando %s..." main-class))
    (message "Este buffer não está associado a um arquivo.")))

(defun my-java-compile-only ()
  "Compila o arquivo Java atual respeitando pacotes."
  (interactive)
  (if-let ((file (buffer-file-name)))
      (progn
        (save-buffer)
        (let ((cmd (format "javac -d . %s" (shell-quote-argument file))))
          (compile cmd)))
    (message "Este buffer não está associado a um arquivo.")))

(defun run-jshell ()
  "Executa JShell no Emacs."
  (interactive)
  (pop-to-buffer
   (make-comint "jshell" "jshell")))

(global-set-key (kbd "<f5>") #'run-java)

(with-eval-after-load 'cc-mode
  (define-key java-mode-map (kbd "<f6>") #'my-java-compile-only))

(provide 'init-java)
;;; init-java.el ends here
