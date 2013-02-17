;; Emacs LIVE
;;
;; This is where everything starts. Do you remember this place?
;; It remembers you...

(add-to-list 'command-switch-alist
             (cons "--live-safe-mode"
                   (lambda (switch)
                     nil)))

(setq live-safe-modep
      (if (member "--live-safe-mode" command-line-args)
          "debug-mode-on"
        nil))

(setq live-supported-emacsp t)

(when live-supported-emacsp

;; Store live base dirs
(setq live-root-dir user-emacs-directory)
(setq
 live-tmp-dir      (file-name-as-directory (concat live-root-dir "tmp"))
 live-etc-dir      (file-name-as-directory (concat live-root-dir "etc"))
 live-lib-dir      (file-name-as-directory (concat live-root-dir "lib"))
 live-packs-dir    (file-name-as-directory (concat live-root-dir "packs"))
 live-autosaves-dir(file-name-as-directory (concat live-tmp-dir  "autosaves"))
 live-backups-dir  (file-name-as-directory (concat live-tmp-dir  "backups"))
 live-load-pack-dir nil)

;; create tmp dirs if necessary
(make-directory live-etc-dir t)
(make-directory live-tmp-dir t)
(make-directory live-autosaves-dir t)
(make-directory live-backups-dir t)

;; Load manifest
(load-file (concat live-root-dir "manifest.el"))

;; load live-lib
(load-file (concat live-lib-dir "live-core.el"))

;;default live packs
(let* ((live-dir (file-name-as-directory "live")))
  (setq live-packs (list (concat live-dir "foundation-pack")
                         (concat live-dir "clojure-pack")
                         (concat live-dir "lang-pack")
                         (concat live-dir "power-pack"))))

;; Helper fn for loading live packs

(defun live-version ()
  (interactive)
  (if (called-interactively-p 'interactive)
      (message "%s" (concat "This is Emacs Live " live-version))
    live-version))


;; Load `~/.emacs-live.el`. This allows you to override variables such
;; as live-packs (allowing you to specify pack loading order)
;; Does not load if running in safe mode
(let* ((pack-file (concat (file-name-as-directory "~") ".emacs-live.el")))
  (if (and (file-exists-p pack-file) (not live-safe-modep))
      (load-file pack-file)))

;; Load all packs - Power Extreme!
(mapcar (lambda (pack-dir)
          (live-load-pack pack-dir))
        (live-pack-dirs))

)

;; ############ TEMPORARY ##  gotta figure out where to put this
;; remap C-x C-b to show buffers in current window
(load-theme 'tsdh-dark t)
(global-set-key (kbd "C-x C-b") 'buffer-menu)
;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "<f12>") 'buffer-menu)
(global-set-key (kbd "<f1>") 'switch-to-buffer)
;;(global-set-key (kbd "<f10>") 'kill-buffer)
(global-set-key (kbd "<f9>") 'goto-line)
(global-set-key (kbd "<f8>") 'linum-mode)
(global-set-key (kbd "<f7>") 'bury-buffer)
(global-set-key (kbd "<f2>") 'sr-speedbar-toggle)
;;(global-set-key (kbd "<f1>") 'other-window)
;; switch to html mode
(global-set-key (kbd "<C-f10>") 'html-mode)
;; switch to javascript mode when working on inline js in html file
(global-set-key (kbd "<C-f11>") 'js-mode)

;; enable line numbers by default and add a space after the number
(global-linum-mode)
(setq linum-format "%d ")

;; set the window title to be filename and path
;; (setq frame-title-format '("Emacs @ " system-name ": %b %+%+ %f"))
(setq frame-title-format '("Emacs @ " ": %b %+%+ %f"))


;; Global settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq line-number-mode t)
(setq column-number-mode t)
(transient-mark-mode t)
(set-default 'indicate-empty-lines t)
(setq inhibit-startup-message t)
(global-auto-revert-mode t)
(global-linum-mode t)
(setq linum-format "%4d ")
(global-hl-line-mode 1)
(global-visual-line-mode 1)
(set-face-background 'hl-line "#305")
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))
(line-number-mode 1)
(set-default 'fill-column 80)
(global-font-lock-mode 1)
(show-paren-mode 1)
(global-set-key "\C-l" 'goto-line)
(setq search-highlight t)

;; Python
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(sclang-auto-scroll-post-buffer t)
 '(sclang-eval-line-forward nil)
 '(sclang-help-path (quote ("/Applications/SuperCollider/Help")))
 '(sclang-runtime-directory "~/.sclang/")
 '(setq sr-speedbar-width-console t)
 '(speedbar-show-unknown-files t)
 '(sr-speedbar-auto-refresh nil)
 '(sr-speedbar-max-width 200)
 '(sr-speedbar-right-side nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Color theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'solarized-dark t)

;; Flymake
(add-to-list 'load-path "~/.emacs.d/vendor")
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pycheckers"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)
