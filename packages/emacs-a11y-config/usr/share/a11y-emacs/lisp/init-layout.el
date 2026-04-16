;; configuração de redimensionamento de janelas
(defvar resize-map (make-sparse-keymap))

(define-key resize-map (kbd "h") #'shrink-window-horizontally)
(define-key resize-map (kbd "l") #'enlarge-window-horizontally)
(define-key resize-map (kbd "j") #'shrink-window)
(define-key resize-map (kbd "k") #'enlarge-window)

(define-minor-mode resize-mode
  "Modo de redimensionamento contínuo."
  :init-value nil
  :lighter " Resize"
  :keymap resize-map)

(global-set-key (kbd "C-c r") #'resize-mode)

;; recupera layouts de janelas
(winner-mode 1)

(provide 'init-layout)
