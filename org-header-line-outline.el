(defvar-local ohlo--header-line-format nil)

(defun ohlo--get-outline-path (&optional maxdepth)
  (let ((maxdepth (or maxdepth 10))
        path)
    (save-excursion
      (while (and (> maxdepth 0)
                  (re-search-backward (format "^\\*\\{1,%d\\} " maxdepth) nil t))
        (push (nth 4 (org-heading-components)) path)
        (setq maxdepth (1- (nth 0 (org-heading-components)))))
      path)))

(defsubst ohlo--outline-to-string (path)
  (concat " " (mapconcat #'identity path " | ")))

(defun ohlo--update-header-line ()
  (let ((pos (car ohlo--header-line-format))
        (pt (point)))
    (unless (and pos (= pos pt))
      (setq org-header-line-format
            (cons pt (ohlo--outline-to-string (ohlo--get-outline-path)))))
    (cdr org-header-line-format)))

(defvar-local ohlo--old-header nil)

(define-minor-mode org-header-line-outline-mode
  "Minor mode to show cursor's outline path in Org mode's header line"
  :lighter nil
  (if org-header-line-outline-mode
      (progn
        (setq ohlo--old-header header-line-format
              header-line-format '(:eval (ohlo--update-header-line))))
    (setq header-line-format ohlo--old-header)))

(provide 'org-header-line-outline-mode)
