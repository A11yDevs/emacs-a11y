;;; init-accessibility.el --- Voz e acessibilidade -*- lexical-binding: t; -*-

;; Configuração básica do backend de voz.
(setenv "DTK_PROGRAM" "espeak")
(setenv "ESPEAK_VOICE" "pt-br")

(setq emacspeak-play-program nil)
(setq emacspeak-use-auditory-icons nil)
(setq emacspeak-line-echo t)
(setq echo-keystrokes 0.1)
(setq ring-bell-function #'ignore)

(defgroup my-accessibility nil
  "Configurações de acessibilidade do usuário."
  :group 'applications)

(defcustom my-emacspeak-setup-file "/opt/emacspeak/lisp/emacspeak-setup.el"
  "Caminho para o arquivo emacspeak-setup.el."
  :type 'file)

(when (file-readable-p my-emacspeak-setup-file)
  (load-file my-emacspeak-setup-file))

(defun my-speak-saved ()
  "Anuncia que o arquivo foi salvo."
  (message "Arquivo salvo.")
  (when (fboundp 'emacspeak-speak-line)
    (emacspeak-speak-line)))

(add-hook 'after-save-hook #'my-speak-saved)

(defun my/emacspeak-process-p (proc)
  "Retorna t se PROC parecer ser um processo do Emacspeak."
  (let ((name (process-name proc))
        (buf  (process-buffer proc)))
    (or (eq proc (and (boundp 'dtk-speaker-process) dtk-speaker-process))
        (and name (string-match-p "speaker\\|dtk\\|tts\\|espeak" name))
        (and buf
             (buffer-live-p buf)
             (string-match-p "speaker\\|dtk\\|tts\\|espeak"
                             (buffer-name buf))))))

(defun my/emacspeak-disable-exit-query ()
  "Desativa a pergunta de saída para processos do Emacspeak."
  (dolist (proc (process-list))
    (when (and (process-live-p proc)
               (my/emacspeak-process-p proc))
      (set-process-query-on-exit-flag proc nil))))

(defun my/emacspeak-cleanup ()
  "Desativa query-on-exit e encerra processos do Emacspeak."
  (my/emacspeak-disable-exit-query)
  (dolist (proc (process-list))
    (when (and (process-live-p proc)
               (my/emacspeak-process-p proc))
      (ignore-errors
        (delete-process proc)))))

(add-hook 'emacs-startup-hook
          (lambda ()
            (run-with-idle-timer 1 nil #'my/emacspeak-disable-exit-query)))

(add-hook 'kill-emacs-hook #'my/emacspeak-cleanup)

(defun my/emacspeak-apply-language ()
  "Aplica português do Brasil ao Emacspeak."
  (when (fboundp 'dtk-set-language)
    (dtk-set-language "pt-br"))
  (setq dtk-speech-rate 180))

(add-hook 'emacs-startup-hook
          (lambda ()
            (run-with-idle-timer 1 nil #'my/emacspeak-disable-exit-query)
            (run-with-idle-timer 2 nil #'my/emacspeak-apply-language)))

(add-hook 'kill-emacs-hook #'my/emacspeak-cleanup)

(defvar my/emacspeak-current-language "pt-br"
  "Idioma atual do Emacspeak controlado pelo usuário.")

(defun my/emacspeak-toggle-language ()
  "Alterna entre português do Brasil e inglês."
  (interactive)
  (when (fboundp 'dtk-stop)
    (dtk-stop))
  (condition-case nil
      (if (string= my/emacspeak-current-language "pt-br")
          (progn
            (dtk-set-language "en")
            (setq my/emacspeak-current-language "en")
            (run-with-timer
             0.2 nil
             (lambda ()
               (when (fboundp 'dtk-speak)
                 (dtk-speak "English mode")))))
        (dtk-set-language "pt-br")
        (setq my/emacspeak-current-language "pt-br")
        (run-with-timer
         0.2 nil
         (lambda ()
           (when (fboundp 'dtk-speak)
             (dtk-speak "Modo português")))))
    (error
     (when (fboundp 'emacspeak-emergency-tts-restart)
       (emacspeak-emergency-tts-restart)))))

(global-set-key (kbd "C-c t") #'my/emacspeak-toggle-language)

(provide 'init-accessibility)
;;; init-accessibility.el ends here
