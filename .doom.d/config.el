;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Deepak Khidia"
      user-mail-address "getchzx@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; start with frame maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(dirvish-override-dired-mode)
;; highligh cursor on jumps
(beacon-mode 1)
(setq vc-handled-backends '(Git))
;; set global aggressive indent mode for all programming modes
;; (add-hook 'prog-mode-hook #'aggressive-indent-mode)



(use-package! deft
  :defer t
  :init
  (global-set-key [f8] 'deft)
  :custom
  (deft-recursive t)
  (deft-use-filename-as-title t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Documents/Drive/org"))

(use-package! org-roam
  :custom
  (org-roam-db-autosync-mode)
  (org-roam-directory "~/Documents/Drive/org/slipbox")
  )

(after! org
  (setq org-ellipsis " ▼")
  (setq org-directory "~/Documents/Drive/org")
  (setq +org-capture-journal-file "~/Documents/Drive/org/journal.org")
  (setq org-agenda-files (list org-directory))
  (setq org-clock-auto-clockout-timer 60)
  (setq org-noter-always-create-frame nil)
  )

(after! magit
  (setq magit-repository-directories '(("~/repos" . 2)))
  (setq magit-clone-default-directory "~/repos")
  )

(after! projectile
  (setq projectile-project-search-path '(("~/repos" . 1))))

(use-package pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  ;;:hook (pdf-tools-enabled . pdf-continuous-scroll-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35")))

(use-package! which-key
  :custom
  (which-key-idle-delay 0.1))

(use-package! helm
  :config
  (map! :leader
        :desc "M-x" "SPC" #'helm-M-x)
  )

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :custom
  (copilot-node-executable "/opt/homebrew/opt/node@16/bin/node")
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         ("M-TAB" . 'copilot-next-completion)
         ("M-<tab>" . 'copilot-next-completion)
         ("M-S-TAB" . 'copilot-previous-completion)
         ("M-S-<tab>" . 'copilot-previous-completion)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))

;; Github codespaces
(use-package! codespaces
  :config
  ;; (codespaces-setup)
  (unless (executable-find "gh")
    (user-error "Could not find `gh' program in your PATH"))
  (unless (featurep 'json)
    (user-error "Emacs JSON support not available; your Emacs is too old"))
  (let ((ghcs (assoc "ghcs" tramp-methods))
        (ghcs-methods '((tramp-login-program "gh")
                        (tramp-login-args (("codespace") ("ssh") ("-c") ("%h")))
                        (tramp-remote-shell "/bin/bash")
                        (tramp-remote-shell-login ("-l"))
                        (tramp-remote-shell-args ("-c")))))
    ;; just for debugging the methods
    (if ghcs (setcdr ghcs ghcs-methods)
      (push (cons "ghcs" ghcs-methods) tramp-methods)))
  (tramp-set-completion-function "ghcs" '((codespaces-tramp-completion ""))))

(use-package! tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; eglot config
;; taken from https://github.com/golang/tools/blob/master/gopls/doc/emacs.md#configuring-eglot
(after! eglot
  :config
  (set-eglot-client! 'python-mode '("pylsp"))
  (set-eglot-client! 'go-mode '("gopls"))


  (defun project-find-go-module (dir)
    (when-let ((root (locate-dominating-file dir "go.mod")))
      (cons 'go-module root)))

  (defun eglot-format-buffer-on-save ()
    (add-hook 'before-save-hook #'eglot-format-buffer -10 t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t)
    (add-hook 'before-save-hook #'eglot-code-action-organize-imports t t)
    )

  (cl-defmethod project-root ((project (head go-module)))
    (cdr project))

  (add-hook 'project-find-functions #'project-find-go-module)
  (add-hook 'go-mode-hook 'eglot-ensure)

  (add-hook 'go-mode-hook #'eglot-format-buffer-on-save)

  (setq-default eglot-workspace-configuration
                '((:gopls .
                   ((staticcheck . t)
                    (matcher . "CaseSensitive")))))
  )

;; (use-package! lsp
;;   :custom
;;   ;; enable gopls over tramp
;;   (lsp-gopls-server-args '("-remote=auto"))
;;   (lsp-go-gopls-server-path "/Users/deepakk/go/bin/gopls")
;;   ;; (lsp-register-client
;;   ;;  (make-lsp-client :new-connection (lsp-tramp-connection "/go/bin/gopls")
;;   ;;                   :major-modes '(go-mode)
;;   ;;                   :remote? t
;;   ;;                   :server-id 'gopls-remote))
;;   ;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;;   )

;; enable completion in insert mode
;(customize-set-variable 'copilot-enable-predicates '(evil-insert-state-p))


;; keybindings
(map!
 "s-b" #'switch-to-buffer
 "s-k" #'kill-this-buffer
 "s-w" #'delete-window
 "C-M-v" #'dee/scroll-other-window
 "C-M-V" #'dee/scroll-other-window-down
 "C-;" #'er/expand-region
 "C-'" #'er/contract-region
 "C-x d" #'dirvish
 :leader
 "b o" #'switch-to-buffer-other-window
 :desc "Shell command" "!" #'shell-command
 )

;; bind u to undo in visual mode
(define-key evil-visual-state-map (kbd "u") 'undo-tree-undo)
(evil-define-key '(normal motion) evil-snipe-local-mode-map (kbd "s") nil) ;; unbind s
(evil-define-key '(operator) evil-snipe-local-mode-map (kbd "s") nil) ;; unbind s
(map! :n "s" #'evil-avy-goto-char-2
      :n "0" 'evil-next-line-1-first-non-blank)


;; hooks
;; Enable undo in non file buffers
;;(add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)

(use-package! gorepl-mode
  :hook (go-mode . gorepl-mode))

;; Scrolling other widnow fix for pdf-mode
(defun dee/scroll-other-window ()
  (interactive)
  (let* ((wind (other-window-for-scrolling))
         (mode (with-selected-window wind major-mode)))
    (if (eq mode 'pdf-view-mode)
        (with-selected-window wind
      (pdf-view-scroll-up-or-next-page))
      (scroll-other-window 2))))

(defun dee/scroll-other-window-down ()
  (interactive)
  (let* ((wind (other-window-for-scrolling))
         (mode (with-selected-window wind major-mode)))
    (if (eq mode 'pdf-view-mode)
    (with-selected-window wind
      (progn
        (pdf-view-scroll-down-or-previous-page)
        (other-window 1)))
      (scroll-other-window-down 2))))
