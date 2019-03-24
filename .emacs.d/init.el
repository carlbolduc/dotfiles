(require 'cc-mode)

(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (require 'use-package)))


(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-message t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell 1)
;;(global-display-line-numbers-mode)

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t)
)

(set-face-attribute 'default nil
                    :family "Iosevka"
                    :height 160
                    :weight 'normal
                    :width 'normal)


(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(windmove-default-keybindings) ;; move between windows using Shift + arrow key https://emacs.stackexchange.com/a/3460

(use-package counsel
  ;; ivy and swiper will be installed as dependencies
  :ensure t
  :config
  (ivy-mode 1)
  (global-set-key (kbd "C-s") 'swiper))

(use-package magit
  :ensure t)

(use-package lsp-mode
  :ensure t
  :config
  (require 'lsp-clients)
  (add-hook 'js2-mode-hook 'lsp))

(use-package projectile :ensure t)
(use-package treemacs :ensure t)
(use-package yasnippet :ensure t)
(use-package lsp-mode :ensure t)
(use-package hydra :ensure t)
(use-package company-lsp :ensure t)
(use-package lsp-ui :ensure t)
(use-package lsp-java :ensure t :after lsp
  :config (add-hook 'java-mode-hook 'lsp))

(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java :after (lsp-java))
(use-package lsp-java-treemacs :after (treemacs))

(setq lsp-language-id-configuration '((java-mode . "java")
                                      (python-mode . "python")
                                      (gfm-view-mode . "markdown")
                                      (rust-mode . "rust")
                                      (css-mode . "css")
                                      (xml-mode . "xml")
                                      (c-mode . "c")
                                      (c++-mode . "cpp")
                                      (objc-mode . "objective-c")
                                      (web-mode . "html")
                                      (html-mode . "html")
                                      (sgml-mode . "html")
                                      (mhtml-mode . "html")
                                      (go-mode . "go")
                                      (haskell-mode . "haskell")
                                      (php-mode . "php")
                                      (json-mode . "json")
                                      (js2-mode . "javascript")
                                      (typescript-mode . "typescript")))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

;; (ido-mode 1)
;; (setq ido-everywhere t)
;; (setq ido-enable-flex-matching t)
;; (require 'helm-config)

;; (use-package dumb-jump
;;   :ensure t
;;   :config
;;   (dumb-jump-mode))

;; Python
;; (use-package anaconda-mode
;;   :ensure t
;;   :config
;;   (add-hook 'python-mode-hook 'anaconda-mode))
;; (use-package company-anaconda
;;   :ensure t
;;   :config
;;   (eval-after-load "company"
;;     '(add-to-list 'company-backends 'company-anaconda)))
(add-hook 'python-mode-hook #'lsp)
(use-package py-yapf
  :ensure t)

;; JavaScript
;; (use-package tide
;;   :ensure t
;;   ;; not sure if we need all this since I'll be coding in JS
;;   :after (typescript-mode company flycheck)
;;   :hook ((typescript-mode . tide-setup)
;;          (typescript-mode . tide-hl-identifier-mode)
;;          (before-save . tide-format-before-save)))
;; (defun setup-tide-mode ()
;;   (interactive)
;;   (tide-setup)
;;   (flycheck-mode +1)
;;   (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;   (eldoc-mode +1)
;;   (tide-hl-identifier-mode +1)
;;   (company-mode +1))
(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (setq-default js2-basic-offset 2)
  ;; (when (executable-find "eslint")
  ;;   (flycheck-select-checker 'javascript-eslint))
)
(use-package rjsx-mode
  :ensure t)
(add-to-list 'lsp-language-id-configuration '(rjsx-mode . "javascript"))
(add-hook 'javascript-mode-hook #'lsp)
;; (use-package prettier-js
;;   :ensure t
;;   :hook ((js2-mode . prettier-js-mode))
;;   :config
;;   ;; (setq prettier-js-args '(
;;   ;;                          "--trailing-comma" "all"
;;   ;;                          "--bracket-spacing" "false"
;;   ;;                          ))
;;   )
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/.bin/eslint"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)


;; json
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

;; Web
(use-package web-mode
  :ensure t
  :config
  (require 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(global-set-key (kbd "M-g f") 'avy-goto-line)


;; Org
(org-babel-do-load-languages 'org-babel-load-languages
                             '(
                               (shell . t)
                               (sql . t)
                               )
                             )






(defun vc-current-dir ()  (interactive)
       (if default-directory (vc-dir default-directory)
         (error "Not in a directory")))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#F0F4FC" "#99324B" "#4F894C" "#9A7500" "#3B6EA8" "#97365B" "#398EAC" "#485163"])
 '(custom-safe-themes
   (quote
    ("6b289bab28a7e511f9c54496be647dc60f5bd8f9917c9495978762b99d8c96a0" "ecba61c2239fbef776a72b65295b88e5534e458dfe3e6d7d9f9cb353448a569e" "cd736a63aa586be066d5a1f0e51179239fe70e16a9f18991f6f5d99732cabb32" "b54826e5d9978d59f9e0a169bbd4739dd927eead3ef65f56786621b53c031a7c" "fe666e5ac37c2dfcf80074e88b9252c71a22b6f5d2f566df9a7aa4f9bea55ef8" "7e78a1030293619094ea6ae80a7579a562068087080e01c2b8b503b27900165c" "9a3366202553fb2d2ad1a8fa3ac82175c4ec0ab1f49788dc7cfecadbcf1d6a81" "058b8c7effa451e6c4e54eb883fe528268467d29259b2c0dc2fd9e839be9c92e" "3cacf6217f589af35dc19fe0248e822f0780dfed3f499e00a7ca246b12d4ed81" "2433283e8d6bf25ee31b8dc1907ee55880c2b2c758c82786788abd1d029f61f9" "e3d6636d03c788a416157c9d34184672b500d63d82de0e2d9f36e9975fd63b9f" "d2868794b5951d57fb30bf223a7e46f3a18bf7124a1c288a87bd5701b53d775a" "add84a254d0176ffc2534cd05a17d57eea4a0b764146139656b4b7d446394a54" "14157dcd9c4e5669d89af65628f4eaf3247e24c2c0d134db48951afb2bdad421" "1438a0656b1b25c0589edcb51229710d8c710ae86ddae4238c5e9226f58ab336" "ec5f697561eaf87b1d3b087dd28e61a2fc9860e4c862ea8e6b0b77bd4967d0ba" default)))
 '(fci-rule-color "#AEBACF")
 '(jdee-db-active-breakpoint-face-colors (cons "#F0F4FC" "#5d86b6"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#F0F4FC" "#4F894C"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#F0F4FC" "#B8C5DB"))
 '(package-selected-packages
   (quote
    (lsp-java lsp-mode lsp-ui company-lsp avy doom-modeline doom-themes counsel-projectile ivy eglot helm-projectile helm web-mode js2-mode tide company-anaconda anaconda-mode magit company projectile counsel flycheck dracula-theme use-package)))
 '(vc-annotate-background "#E5E9F0")
 '(vc-annotate-color-map
   (list
    (cons 20 "#4F894C")
    (cons 40 "#688232")
    (cons 60 "#817b19")
    (cons 80 "#9A7500")
    (cons 100 "#a0640c")
    (cons 120 "#a65419")
    (cons 140 "#AC4426")
    (cons 160 "#a53f37")
    (cons 180 "#9e3a49")
    (cons 200 "#97365B")
    (cons 220 "#973455")
    (cons 240 "#983350")
    (cons 260 "#99324B")
    (cons 280 "#a0566f")
    (cons 300 "#a87b93")
    (cons 320 "#b0a0b6")
    (cons 340 "#AEBACF")
    (cons 360 "#AEBACF")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
