;; forked from https://github.com/dandavison/org-fold
;; adjusted to work with Emacs 29.4

(setq org-fold-directory "~/org/org-fold/")

(unless (file-exists-p org-fold-directory)
  (make-directory org-fold-directory))

(defun org-fold-get-fold-info-file-name ()
  (concat org-fold-directory (buffer-name) ".fold"))

(defun org-fold-save ()
  (save-excursion
    (goto-char (point-min))
    (let (foldstates)
      (unless (looking-at outline-regexp)
        (outline-next-visible-heading 1))
      (while (not (eobp))
        (push (invisible-p (line-end-position)) foldstates)
        (outline-next-visible-heading 1))
      (with-temp-file (org-fold-get-fold-info-file-name)
        (prin1 (nreverse foldstates) (current-buffer))))))

(defun org-fold-restore ()
  (save-excursion
    (goto-char (point-min))
    (let* ((foldfile (org-fold-get-fold-info-file-name))
           (foldstates
            (if (file-readable-p foldfile)
                (with-temp-buffer
                  (insert-file-contents foldfile)
                  (read (current-buffer))))))
      (when foldstates
        (show-all)
        (goto-char (point-min))
        (unless (looking-at outline-regexp)
          (outline-next-visible-heading 1))
        (while (and foldstates (not (eobp)))
          (if (pop foldstates)
              (hide-subtree))
          (outline-next-visible-heading 1))
        (message "Restored saved folding state")
        (message (org-fold-get-fold-info-file-name))
        ))))

(add-hook 'org-mode-hook 'org-fold-activate)

(defun org-fold-activate ()
  (org-fold-restore)
  (add-hook 'before-save-hook 'org-fold-save        nil t)
  (add-hook 'auto-save-hook   'org-fold-kill-buffer nil t))

(defun org-fold-kill-buffer ()
  ;; don't save folding info for unsaved buffers
  (unless (buffer-modified-p)
    (org-fold-save)))
