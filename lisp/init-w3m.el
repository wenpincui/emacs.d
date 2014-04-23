(require-package 'w3m)

(setq browse-url-browser-function 'w3m-browse-url)
(setq w3m-command-arguments '("-cookie" "-F"))

(setq w3m-use-cookies t)

(setq w3m-show-graphic-icons-in-header-line t)
(setq w3m-show-graphic-icons-in-mode-line t)

(setq w3m-view-this-url-new-session-in-background t)

(add-hook 'w3m-fontify-after-hook 'remove-w3m-output-garbages)

(defun remove-w3m-output-garbages ()
  "去掉w3m输出的垃圾."
  (interactive)
  (let ((buffer-read-only))
    (setf (point) (point-min))
    (while (re-search-forward "[\200-\240]" nil t)
      (replace-match " "))
    (set-buffer-multibyte t))
  (set-buffer-modified-p nil))

(provide 'init-w3m)
