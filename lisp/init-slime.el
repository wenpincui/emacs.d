(require-package 'slime)
;; package.el compiles the contrib subdir, but the compilation order
;; causes problems, so we remove the .elc files there. See
;; http://lists.common-lisp.net/pipermail/slime-devel/2012-February/018470.html
(mapc #'delete-file
      (file-expand-wildcards (concat user-emacs-directory "elpa/slime-2*/contrib/*.elc")))

(require-package 'ac-slime)
(require-package 'hippie-expand-slime)


;;; Lisp buffers

(defun sanityinc/slime-setup ()
  "Mode setup function for slime lisp buffers."
  (set-up-slime-hippie-expand)
  (set-up-slime-ac t))

(after-load 'slime
  (setq slime-protocol-version 'ignore)
  (setq slime-net-coding-system 'utf-8-unix)
  (slime-setup '(slime-fancy))
  (setq slime-complete-symbol*-fancy t)
  (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
  (add-hook 'slime-mode-hook 'sanityinc/slime-setup))


;;; REPL

(defun sanityinc/slime-repl-setup ()
  "Mode setup function for slime REPL."
  (sanityinc/lisp-setup)
  (set-up-slime-hippie-expand)
  (set-up-slime-ac t)
  (setq show-trailing-whitespace nil))

(after-load 'slime-repl
  ;; Stop SLIME's REPL from grabbing DEL, which is annoying when backspacing over a '('
  (after-load 'paredit
    (define-key slime-repl-mode-map (read-kbd-macro paredit-backward-delete-key) nil)
    (define-key slime-repl-mode-map (kbd "M-s") 'paredit-splice-sexp))

  (let ((local-hyper-spec "~/.quicklisp/clhs-use-local.el"))
      (and (file-exists-p local-hyper-spec)
           (load local-hyper-spec)))

  (define-key slime-repl-mode-map (kbd "C-c l")
    'slime-documentation)
  (define-key slime-mode-map (kbd "C-c l")
    'slime-documentation)

  ;; Bind TAB to `indent-for-tab-command', as in regular Slime buffers.
  (define-key slime-repl-mode-map (kbd "TAB") 'indent-for-tab-command)

  (add-hook 'slime-repl-mode-hook 'sanityinc/slime-repl-setup))

(after-load 'auto-complete
  (add-to-list 'ac-modes 'slime-repl-mode))

(provide 'init-slime)
