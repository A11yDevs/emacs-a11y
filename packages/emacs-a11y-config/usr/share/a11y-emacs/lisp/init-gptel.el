;;; init-gptel.el --- Configuração do gptel -*- lexical-binding: t; -*-

(when (and (my/package-installed-or-warn 'gptel)
           (my/package-installed-or-warn 'dot-env))
  (require 'gptel)
  (require 'dot-env)

  (let ((env-file (expand-file-name ".env" user-emacs-directory)))
    (when (file-exists-p env-file)
      (dot-env-config env-file)))

  (let ((my/gptel-api-key (getenv "OPENROUTER_API_KEY")))
    (if (not my/gptel-api-key)
        (message "init-gptel: OPENROUTER_API_KEY não encontrada no ambiente ou no arquivo .env")
      (setq gptel-backend
            (gptel-make-openai
             "OpenRouter"
             :host "openrouter.ai"
             :endpoint "/api/v1/chat/completions"
             :key my/gptel-api-key))

      (setq gptel-model 'openrouter/gpt-5.4-mini)
      (setq gptel-stream nil)
      (setq gptel-log-level 'debug))))

(provide 'init-gptel)
;;; init-gptel.el ends here
