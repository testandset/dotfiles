
;; Move visual lines instead of actual lines
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; (define-key evil-normal-state-map (kbd "DEL") 'pop-global-mark)

;; Window undo
(define-key evil-normal-state-map (kbd "s-b") 'helm-mini)
(define-key evil-normal-state-map (kbd "s-k") 'kill-this-buffer)
(define-key evil-normal-state-map (kbd "s-w") 'delete-window)

(define-key evil-normal-state-map (kbd "s") 'evil-avy-goto-char-2)

(define-key evil-normal-state-map (kbd "0") 'evil-next-line-1-first-non-blank)
(define-key evil-normal-state-map (kbd "_") 'evil-digit-argument-or-evil-beginning-of-line)
(define-key evil-normal-state-map (kbd "C-x c") 'aya-create)
(define-key evil-normal-state-map (kbd "C-x e") 'spacemacs/auto-yasnippet-expand)

(spacemacs/set-leader-keys
  "bo" 'switch-to-buffer-other-window
  "sh" 'helm-resume
  )
