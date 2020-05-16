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

(defun dee/convert-to-jira ()
  "Convert org mode to jira markdown"
  (interactive)
  (push-mark (save-excursion
               (pandoc-set-write "org")
               (pandoc--call-external "jira" nil (when (use-region-p) (cons (region-beginning) (region-end))))
               (sit-for 1)
               (replace-buffer-contents (get-buffer pandoc--output-buffer-name))
               )))

(defun dee/org-archive-done-tasks ()
  "Archive all done tasks in buffer"
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'tree))
