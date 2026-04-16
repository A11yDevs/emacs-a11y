;;; init-activities.el --- Activities e navegação -*- lexical-binding: t; -*-

(setq edebug-inhibit-emacs-lisp-mode-bindings t)

(when (my/package-installed-or-warn 'activities)
  (use-package activities
    :config
    (activities-mode 1)
    (when (fboundp 'activities-tabs-mode)
      (activities-tabs-mode -1))
    :bind
    (("C-x C-a C-n" . activities-new)
     ("C-x C-a C-d" . activities-define)
     ("C-x C-a C-a" . activities-resume)
     ("C-x C-a C-s" . activities-suspend)
     ("C-x C-a C-k" . activities-kill)
     ("C-x C-a RET" . activities-switch)
     ("C-x C-a b" . activities-switch-buffer)
     ("C-x C-a g" . activities-revert)
     ("C-x C-a l" . activities-list))))

(setq tab-bar-show 0)
(tab-bar-mode -1)
(global-set-key (kbd "C-x C-b") #'ibuffer)

(provide 'init-activities)
;;; init-activities.el ends here
