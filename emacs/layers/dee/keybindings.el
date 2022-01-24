
;; Move visual lines instead of actual lines
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; (define-key evil-normal-state-map (kbd "DEL") 'pop-global-mark)

;; Window undo
(define-key evil-normal-state-map (kbd "C-;") 'winner-undo)
(define-key evil-normal-state-map (kbd "C-\'") 'winner-redo)

(global-set-key (kbd "s-b") 'helm-mini)
(global-set-key (kbd "s-k") 'kill-this-buffer)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-=") 'spacemacs/scale-font-transient-state/spacemacs/scale-up-font)
(global-set-key (kbd "s--") 'spacemacs/scale-font-transient-state/spacemacs/scale-down-font)
(global-set-key (kbd "s-0") 'spacemacs/scale-font-transient-state/spacemacs/reset-font-size)

(define-key evil-normal-state-map (kbd "s") 'evil-avy-goto-char-2)

(define-key evil-normal-state-map (kbd "0") 'evil-next-line-1-first-non-blank)
(define-key evil-normal-state-map (kbd "_") 'evil-digit-argument-or-evil-beginning-of-line)
(define-key evil-normal-state-map (kbd "C-x c") 'aya-create)
(define-key evil-normal-state-map (kbd "C-x e") 'spacemacs/auto-yasnippet-expand)
(define-key evil-visual-state-map (kbd "D") "\"_d")

(spacemacs/set-leader-keys
  "bo" 'switch-to-buffer-other-window
  "bn" 'spacemacs/new-empty-buffer
  "sh" 'helm-resume
  )
