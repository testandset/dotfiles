;;; packages.el --- dee layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Deepak Khidia
;; URL: https://github.com/getchzx
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET

(defconst dee-packages
  '(
    ;; installs
    beacon ;; blink cursor on jumps
    persistent-scratch
    git-link
    engine-mode
    git-gutter ;; show markers on the left margin for changed/added/deleted lines

    ;; depends
    org
    treemacs
    dired
    spacemacs-buffer-mode
    edit-server
    magit
    lsp-ui-mode
    dumb-jump
    prog-mode
    global-company-mode
    )
  "The list of Lisp packages required by the dee layer"
  )


(defun dee/init-beacon ()
  (use-package beacon :defer t))

(defun dee/post-init-beacon ()
  (beacon-mode 1)
  )

(defun dee/init-persistent-scratch ()
  (use-package persistent-scratch
    :defer t
    :init
    ;; auto save/restore scratch buffer
    (persistent-scratch-setup-default)))

(defun dee/post-init-git-link ()
  (use-package git-link
                :defer t
                :init
                (eval-after-load 'git-link
                  '(progn
                     (add-to-list 'git-link-remote-alist
                                  '("ghe.spotify.net" git-link-github))
                     (add-to-list 'git-link-commit-remote-alist
                                  '("ghe.spotify.net" git-link-commit-github))))
                ))

(defun dee/init-engine-mode ()
  (use-package engine-mode
    :defer t
    :config
    (engine/set-keymap-prefix (kbd "s-/"))
    (defengine google
      "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
      :keybinding "g"
      )
    ))

(defun dee/post-init-engine-mode ()
  (engine-mode t)
  )

(defun dee/post-init-git-gutter ()
  (use-package git-gutter
    :defer t
    :init
    (setq git-gutter:hide-gutter t)
    (setq git-gutter:lighter " ġ")
    ))

(defun dee/post-init-org ()
  (with-eval-after-load 'org
    ;; Replace org ... with fancy
    (setq org-ellipsis " ▼")
    (setq org-directory "~/Documents/Drive/org")
    (setq org-agenda-files (list org-directory))

    (setq org-capture-templates
          '(("t" "Todo" entry (file+headline "~/Documents/Drive/org/tasks.org" "Tasks")
             "* TODO %?\n  %U\n  %i\n  %a")
            ("s" "Code Snippet" entry
             (file "~/Documents/Drive/org/snippets.org")
             ;; Prompt for tag and language
             "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
            ))

    ;; org auto complete sections
    (setq org-structure-template-alist
          (quote
           (("a" . "export ascii")
            ("c" . "center")
            ("C" . "comment")
            ("e" . "example")
            ("E" . "export")
            ("h" . "export html")
            ("l" . "export latex")
            ("q" . "quote")
            ("s" . "src")
            ("v" . "verse"))))
    )
  )

(defun dee/post-init-treemacs ()
  (with-eval-after-load 'treemacs
    (defun dee/treemacs-ignore-files (file _)
      (s-suffix? file ".pyc") ;; compiled python files
      )
    (push #'dee/treemacs-ignore-files treemacs-ignored-file-predicates))
  )

(defun dee/post-init-dired ()
  ;; ls on osx does not support dired
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil))

  (with-eval-after-load 'dired
    (bind-keys :map dired-mode-map
               ("i" . dired-subtree-toggle)
               ("/" . helm-swoop)))

  ;; reuse dired buffers
  (add-hook 'dired-mode-hook
            (lambda ()
              (define-key dired-mode-map (kbd "^")
                (lambda () (interactive) (find-alternate-file "..")))
                                        ; was dired-up-directory
              ))
  )

(defun dee/post-init-spacemacs-buffer-mode ()
  (add-hook 'spacemacs-buffer-mode-hook
            (lambda ()
              (define-key spacemacs-buffer-mode-map (kbd "s-b") 'helm-mini)))
  )

(defun dee/post-init-edit-server ()
  ;; Switch back to chrome after editing
  (add-hook 'edit-server-done-hook (lambda () (shell-command "open -a \"Google Chrome\"")))
  )

(defun dee/post-init-magit ()
  (setq magit-repository-directories '(("~/repos" . 2)))
  (with-eval-after-load 'magit
    (autoload 'org-read-date "org")

    (defun magit-org-read-date (prompt &optional _default)
      (org-read-date 'with-time nil nil prompt))

    (magit-define-popup-option 'magit-log-popup
      ?s "Since date" "--since=" #'magit-org-read-date)

    (magit-define-popup-option 'magit-log-popup
      ?u "Until date" "--until=" #'magit-org-read-date)

    ;; enable spell check for commit
    (add-hook 'git-commit-setup-hook 'git-commit-turn-on-flyspell)
    )
  )

(defun dee/post-init-lsp-ui-mode ()
  (with-eval-after-load 'lsp-ui
    (setq lsp-ui-sideline-show-code-actions nil)
    (setq lsp-ui-sideline-show-symbol nil)
    (lsp-ui-sideline-toggle-symbols-info)
    (setq lsp-ui-doc-enable nil)
    (setq lsp-java-format-settings-url "~/Documents/spotify-checkstyle-idea.xml")

    ;; no order as that is as per Intellij
    (setq lsp-java-import-order nil))
  )

(defun dee/post-init-dumb-jump ()
  (dumb-jump-mode)
  (with-eval-after-load 'dumb-jump
    (define-key evil-normal-state-map (kbd "M-g o") 'dumb-jump-go-other-window)
    (define-key evil-normal-state-map (kbd "C-]") 'dumb-jump-go)
    (define-key evil-normal-state-map (kbd "M-g j") 'dumb-jump-go)
    (define-key evil-normal-state-map (kbd "M-g i") 'dumb-jump-go-prompt)
    (define-key evil-normal-state-map (kbd "M-g x") 'dumb-jump-go-prefer-external)
    )
  )

(defun dee/post-init-prog-mode ()
  ;; Treat underscores as part of word in programming modes
  (add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  )

(defun dee/post-init-global-company-mode ()
  (global-company-mode) ;; enable auto-complete globally
  )
