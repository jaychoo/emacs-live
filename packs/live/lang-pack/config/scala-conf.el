(live-add-pack-lib "scala-mode")
(require 'scala-mode)

(add-hook 'scala-mode-hook
      (lambda () (local-set-key (kbd "RET") 'reindent-then-newline-and-indent)))
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
