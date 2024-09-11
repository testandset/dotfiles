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
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Drive/org")

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
(add-hook 'text-mode-hook (lambda () (writegood-mode -1)))
(add-hook 'org-mode-hook (lambda () (writegood-mode -1)))

(setq vc-handled-backends '(Git))
;; set global aggressive indent mode for all programming modes
;; (add-hook 'prog-mode-hook #'aggressive-indent-mode)

;; set up flyspell for all text modes
(add-hook 'text-mode-hook #'flyspell-mode)

;; set up flyspell for all programming modes
(add-hook 'prog-mode-hook #'flyspell-prog-mode)

;; set up flyspell for magit commit messages
(add-hook 'git-commit-mode-hook #'flyspell-mode)

(setq world-clock-list
      '(
        ("America/New_York" "New York")
        ("Asia/Calcutta" "Delhi")
        ("Europe/London" "London")
        ("America/Chicago" "Austin")
        ("Australia/Sydney" "Sydney")
        ("Asia/Tokyo" "Tokyo")))

(after! org
  ;; (setq org-ellipsis " ▼")
  (setq org-directory "~/Documents/Drive/org")
  (setq org-agenda-files
        (mapcar (lambda (file) (expand-file-name file org-directory))
                '("todo.org" "journal.org")))
  (setq org-clock-auto-clockout-timer 60)
  (setq org-noter-always-create-frame nil)
  (setq org-log-done 'time)

  ;; first remove the old catpture template for t
  (setq org-capture-templates (delq (assoc "t" org-capture-templates) org-capture-templates))
  (add-to-list 'org-capture-templates
               '("t" "Personal todo" entry
                 (file+headline +org-capture-todo-file "Inbox")
                 "* TODO %?\n%i\n%a" :prepend t)
               )

  ;; add hook to org-mode to enable auto-save
  (add-hook 'org-mode-hook 'auto-save-mode)

  ;; Bind the function to a key combination in org-mode
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c d") 'insert-current-date-org-format)))

  (add-hook 'org-trigger-hook 'save-buffer)

  ;; set up epub export
  ;; (require 'ox-epub)
  )

;; (use-package! org-modern
;;   :after org
;;   :config
;;   (global-org-modern-mode))


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
  :after org
  :custom
  (org-roam-db-autosync-mode)
  (org-roam-directory "~/Documents/Drive/org/slipbox")
  )


(use-package! org-agenda
  :after org
  :config
  (setq org-agenda-show-future-repeats nil)
  (add-to-list 'org-agenda-custom-commands
               '("d" "Daily Agenda"
                 (
                  (agenda ""
                          ((org-agenda-files '("journal.org"))
                           (org-agenda-overriding-header "Week Schedule")
                           ))

                  (alltodo "" ((org-agenda-files '("journal.org"))
                               (org-agenda-overriding-header "Tasks:")
                               (org-agenda-skip-function
                                (lambda() (or
                                           (org-agenda-skip-entry-if 'todo '("IDEA"))
                                           (org-agenda-skip-entry-if 'scheduled))))))
                  (alltodo ""
                           ((org-agenda-files '("journal.org"))
                            (org-agenda-overriding-header "Ideas:")
                            (org-agenda-skip-function
                             (lambda ()
                               (org-agenda-skip-entry-if 'notregexp "IDEA")))
                            ))
                  (alltodo "" ((org-agenda-files '("todo.org"))
                               (org-agenda-overriding-header "Back Burner:")
                               (org-agenda-skip-function
                                '(org-agenda-skip-entry-if 'todo '("IDEA")))))
                  ))))

(use-package! org-reverse-datetree
  :after org
  :config
  (setq-default org-reverse-datetree-level-formats
                '("%Y"                    ; year
                  (lambda (time) (format-time-string "%Y-%m %B" (org-reverse-datetree-monday time))) ; month
                  "%Y-%m-%d %A"           ; date
                  ))

  (setq org-capture-templates (delq (assoc "j" org-capture-templates) org-capture-templates))
  (add-to-list 'org-capture-templates
               '("j" "Journal" entry
                 (file+function +org-capture-journal-file
                                (lambda ()
                                  (goto-char (point-min))
                                  (outline-next-heading) ;; ignore the *Daily Tasks* heading
                                  (org-reverse-datetree-goto-date-in-file)))
                 "* %?\n%i\n" :prepend t))
  (evil-define-key '(normal) calendar-mode-map (kbd "RET") #'org-reverse-datetree-display-entry)
  )

;; set up org-download
(use-package! org-download
  :config
  (setq org-download-method 'directory)
  (setq org-download-image-org-width 600)
  (setq org-download-image-dir "~/Documents/Drive/org/images")
  (setq org-download-link-format "[[file:%s]]\n"
        org-download-abbreviate-filename-function #'file-relative-name)
  (setq org-download-link-format-function #'org-download-link-format-function-default)
  )


(after! magit
  (setq magit-repository-directories '(("~/repos" . 2)))
  (setq magit-clone-default-directory "~/repos")
  )

(after! 'browse-at-remote
  (add-to-list 'browse-at-remote-remote-type-regexps
               '("your\\.ghe\\.spotify\\.net" . "github")))


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

;; (use-package! helm
;;   :config
;;   (map! :leader
;;         :desc "M-x" "SPC" #'helm-M-x)
;;   )

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
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :custom
;;   (copilot-node-executable "/opt/homebrew/bin/node")
;;   :bind (("C-TAB" . 'copilot-accept-completion-by-word)
;;          ("C-<tab>" . 'copilot-accept-completion-by-word)
;;          ("M-TAB" . 'copilot-next-completion)
;;          ("M-<tab>" . 'copilot-next-completion)
;;          ("M-S-TAB" . 'copilot-previous-completion)
;;          ("M-S-<tab>" . 'copilot-previous-completion)
;;          :map copilot-completion-map
;;          ("<tab>" . 'copilot-accept-completion)
;;          ("TAB" . 'copilot-accept-completion)))

;; (use-package! tramp
;;   :config
;;   (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

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

(use-package! gptel
  :config
  ;; (add-to-list 'gptel-directives
  ;;              '(debugging . "You are a large language model and a skilled debugger. Assist in identifying and fixing issues in code, providing explanations when necessary."))
  (setq! gptel-default-mode 'org-mode)
  (setq! gptel-org-branching-context t)
  )


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
 :desc "gptel-send" "C-c RET" #'gptel-send
 :n "F19" #'+org/toggle-last-clock
 :leader
 :desc "M-x" "SPC" #'execute-extended-command
 :desc "Dee Agenda" "o a d" (lambda () (interactive) (org-agenda nil "d"))
 :desc "gptel" "RET" #'gptel
 "b o" #'switch-to-buffer-other-window
 ;; :desc "Find org file" "n f" #'dee/helm-org-files
 :desc "Open journal" "n j" (lambda () (interactive) (find-file (concat org-directory "/journal.org")))
 "w H" #'evil-window-move-far-left
 "w L" #'evil-window-move-far-right
 "w J" #'evil-window-move-very-bottom
 "w K" #'evil-window-move-very-top
 :desc "Shell command" "!" #'shell-command
 :map org-mode-map
 :localleader
 "O" #'org-occur
 )


;; bind u to undo in visual mode
(define-key evil-visual-state-map (kbd "u") 'undo-tree-undo)
(evil-define-key '(normal motion) evil-snipe-local-mode-map (kbd "s") nil) ;; unbind s
(evil-define-key '(operator) evil-snipe-local-mode-map (kbd "s") nil) ;; unbind s
(map! :n "s" #'evil-avy-goto-char-timer
      :n "0" 'evil-next-line-1-first-non-blank)


;; hooks
;; Enable undo in non file buffers
;;(add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)

(use-package! gorepl-mode
  :hook (go-mode . gorepl-mode))

;; Scrolling other window fix for pdf-mode
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

;; (defun dee/helm-org-files ()
;;   "Find org file"
;;   (interactive)
;;   (helm :sources (helm-build-sync-source "Org Files"
;;                    :candidates (lambda ()
;;                                  (mapcar (lambda (x) (cons (file-name-nondirectory x) x))
;;                                          (directory-files-recursively org-directory "\.org$")))
;;                    :action '(("Find file" . (lambda (candidate)
;;                                               (find-file candidate)))))))

(use-package! sqlformat
  :custom
  (sqlformat-command 'pgformatter)
  :hook (sql-mode . sqlformat-on-save-mode))

;; set up doc mode keybindings
;; http://yummymelon.com/devnull/personalizing-emacs-doc-navigation.html
;; (load! "cc-doc-mode-ux.el")
;; (require 'cc-doc-mode-ux)

;; set up sql-connection-alist
(setq sql-connection-alist
      '((source-db
         (sql-product 'postgres)
         (sql-port 5435)
         (sql-server "localhost")
         (sql-user "moog-synth@gke-accounts.iam")
         (sql-database "postgres"))
        (domain-db
         (sql-product 'postgres)
         (sql-port 5433)
         (sql-server "localhost")
         (sql-user "moog-synth@gke-accounts.iam")
         (sql-database "postgres"))))

;; Cloud SQL Proxy
(defvar cloud-sql-connection-configs
  '(("source-db" . "spotify-moog:europe-west1:source-db-primary=tcp:5435")
    ("domain-db" . "spotify-moog:europe-west1:moog-domain=tcp:5433")
    ))

(defun dee/cloud-sql-proxy (config)
  "Start or restart the Google Cloud SQL Proxy for the specified CONFIG."
  (interactive
   (list (completing-read "Choose a Cloud SQL instance configuration: " cloud-sql-connection-configs nil t)))
  (let* ((config-entry (assoc config cloud-sql-connection-configs))
         (instance-name (car config-entry))
         (connection (cdr config-entry))
         (process-name (format "cloud-sql-proxy-%s" instance-name)))
    ;; if the process is already running, kill it
    (async-shell-command
     (format "cloud_sql_proxy -instances=%s -enable_iam_login --token=$(gcloud auth print-access-token --impersonate-service-account=moog-synth@gke-accounts.iam.gserviceaccount.com)" connection)
     process-name)))

(defun dee/org-export-all-html ()
  "Merge all org notes in a file and export it to html"
  (interactive)
  (let (
        (files (directory-files (concat org-directory "/slipbox") t "\.org$"))
        (merged-file "notes.org")
        )
    (with-temp-buffer merged-file
                      (insert "#+TITLE: Notes\n")
                      (insert "#+SETUPFILE: https://fniessen.github.io/org-html-themes/org/theme-readtheorg.setup\n")
                      (insert "#+OPTIONS: broken-links:mark\n")
                      (dolist
                          ;; files are named with a date-name format, sort them by name
                          ;; split the file name by - and take the last part
                          (file (sort files (lambda (a b) (string< (car (last (split-string a "-"))) (car (last (split-string b "-")))))))
                        (let ((file-contents (with-temp-buffer
                                               (insert-file-contents file)
                                               (buffer-string)))
                              (file-title (with-temp-buffer
                                            (insert-file-contents file)
                                            (goto-char (point-min))
                                            (re-search-forward "^#\\+TITLE: \\(.*\\)$")
                                            (match-string 1))))
                          (insert "* " file-title "\n")
                          (insert (replace-regexp-in-string "^" "  " file-contents))

                          ))
                      ;; write file in org-directory
                      (write-file (concat org-directory "/" merged-file))
                      (org-html-export-to-html)
                      )
    )
  )

;; run function asynchrounously
;; (async-start dee/org-export-all-html)

(defun dee/gptel-rewrite (bounds &optional directive)
  (interactive
   (list
    (cond
     ((use-region-p) (cons (region-beginning) (region-end)))
     ((derived-mode-p 'text-mode)
      (list (bounds-of-thing-at-point 'sentence)))
     (t (cons (line-beginning-position) (line-end-position))))
    (let ((choice (completing-read "Choose directive: "
                                   '("Rewrite professionally"
                                     "Elaborate and simplify"
                                     "Rewrite Git message"
                                     "Custom"))))
      (cond
       ((string= choice "Rewrite professionally")
        "You are a prose editor. Rewrite my prompt more professionally.")
       ((string= choice "Elaborate and simplify")
        "You are a prose editor. Elaborate and simplify my prompt.")
       ((string= choice "Rewrite Git message")
        "Rewrite the following Git commit message to be more clear and concise. Ensure the first line is a title limited to 50 characters, followed by a more detailed description")
       (t
        (read-string "Enter your custom directive: "))))))
  (gptel-request
      (buffer-substring-no-properties (car bounds) (cdr bounds)) ;the prompt
    :system (or directive "You are a prose editor. Rewrite my prompt more professionally.")
    :buffer (current-buffer)
    :context (cons (set-marker (make-marker) (car bounds))
                   (set-marker (make-marker) (cdr bounds)))
    :callback
    (lambda (response info)
      (if (not response)
          (message "ChatGPT response failed with: %s" (plist-get info :status))
        (let* ((bounds (plist-get info :context))
               (beg (car bounds))
               (end (cdr bounds))
               (buf (plist-get info :buffer)))
          (with-current-buffer buf
            (save-excursion
              (goto-char end)
              (insert "\n-----\n" response)
              (set-marker beg nil)
              (set-marker end nil)
              (message "Rewrote text"))))))))

(defun dee/org-add-journal-entry ()
  "Add a journal entry when a repeated task is marked as done and print the task name."
  (save-excursion (let ((isDone (string= "TODO" (org-get-todo-state)))
                        (task (org-get-heading t t t t))
                        (isScheduled (org-get-scheduled-time (point))))

                    (when (and isDone isScheduled)
                      (message "adding to journal")
                      (org-reverse-datetree-goto-date-in-file)
                      (or (bolp) (insert "\n")) ;; Ensure a new line if not at the beginning of a line
                      (insert (concat "**** " "Finished scheduled task: " task))
                      )
                    )))


(add-hook 'org-after-todo-state-change-hook 'dee/org-add-journal-entry)
