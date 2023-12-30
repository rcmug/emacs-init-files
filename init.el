;; -*-emacs-lisp-*-
;;

;; Load add-on packages
(require 'package)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (scala-mode markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; Load custom local libraries
(if (file-directory-p (expand-file-name "~/.emacs.d/elisp"))
    (progn
      (setq load-path (cons (expand-file-name "~/.emacs.d/elisp") load-path))
      (if (file-exists-p (expand-file-name "~/.emacs.d/elisp/plantuml-mode.el"))
          (progn
            ;;(setq plantuml-java-args '("-jar"))
	    (load-library "plantuml-mode.el")
	    (setq plantuml-jar-path (concat "C:/cygwin64" (expand-file-name "~/") ".emacs.d/elisp/plantuml.jar"))
	    (setq plantuml-file-output-path "/tmp/plantuml-mode-output.png")
	    (setq plantuml-external-browser-path "/cygdrive/c/Program Files (x86)/Mozilla Firefox/firefox.exe")
	    (setq plantuml-external-browser-args (list (concat "file:///C:/cygwin64" plantuml-file-output-path)))
	    (setq plantuml-file-output-type 'png)
	    ;;(setq plantuml-jar-path (concat "C:/cygwin64" (expand-file-name "~/") ".emacs.d/elisp/plantuml.jar"))
	    ;;(setq plantuml-png-path "C:/cygwin64/tmp/plantuml-mode-output.png")
	    ;;(setq plantuml-browser-input-path (concat "file://" plantuml-png-path))
	    ;;(setq plantuml-browser-exec-path "/cygdrive/c/Program Files (x86)/Mozilla Firefox/firefox.exe")
	    ))
      (if (file-exists-p (expand-file-name "~/.emacs.d/elisp/markdown-mode.el"))
          (progn
            ;;(setq plantuml-java-args '("-jar"))
	    (load-library "markdown-mode.el")
	    ))
      ))


;; Key bindings
(let ((temp (make-string 128 0)))
  (let ((i 0))
    (while (< i 128)
      (aset temp i i)
      (setq i (1+ i))))
  (aset temp 8 127)
  (setq keyboard-translate-table temp))

(global-set-key "\M-%" 'query-replace-regexp)
(global-set-key "\M-^" 'query-replace)
(global-set-key "\M-*" 'replace-regexp)
(global-set-key "\M-&" 'replace-string)
(global-set-key "\M-#" 'goto-line)

;; Window operation key behavior
(put 'narrow-to-region 'disabled nil)
(setq split-height-threshold 1) ;; auto split window default set to horizontal. (nil for vertical)

;; Appearance
(setq frame-background-mode 'dark)
(setq select-active-retions nil)
(setq mouse-drag-copy-region t)
(global-set-key [mouse-2] 'mouse-yank-at-click)
(setq default-input-method 'japanese)

(setq-default indent-tabs-mode t)
(setq indent-tabs-mode t)

(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.saves"))  ; don't litter my fs tree
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t       ; use versioned backups
      inhibit-startup-screen t
      inhibit-startup-buffer-menu t)

(setq x-select-enable-clipboard t)

;; Language
(setq default-input-method 'japanese)
(set-terminal-coding-system 'utf-8)

;; Ruby mode
(defun ruby-mode-init ()
  (setq indent-tabs-mode t))
(add-hook 'ruby-mode-hook 'ruby-mode-init)
(setq ruby-indent-level 8)

;; C/C++ mode
;;(add-hook 'c-mode-common-hook '(lambda () (c-set-style "java")))
(add-hook 'c-mode-common-hook #'(lambda () (c-set-style "stroustrup")))
(add-hook 'c++-mode-common-hook #'(lambda () (c-set-style "stroustrup")))

;; Custom functions
(defun bf-pretty-print-xml-buffer ()
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive)
  (xf-pretty-print-xml-region (point-min) (point-max)))

(defun xf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (save-restriction
      (nxml-mode)
      (narrow-to-region begin end)
      (goto-char (point-min))
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
	(backward-char) (insert "\n"))
      (goto-char (point-max))
      (unless (bolp) (insert "\n"))
      (goto-char (point-max))
      (indent-region (point-min) (point-max))
      (message "Ah, much better!"))))

(setq auto-mode-alist
      (append
       ;; File name (within directory) starts with a dot.
       '(;; File name ends in ‘.h’.
	 ("\\.h\\'" . c++-mode))
       auto-mode-alist))
