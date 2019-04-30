(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-enable-at-startup nil)
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (eval-when-compile
    (require 'use-package))
  (setq use-package-verbose nil)
  (setq use-package-always-ensure t)
  (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
  )
(require 'cl)

(defvar my/packages '(
		      company
		      hungry-delete
		      swiper
		      counsel
		      smartparens
		      exec-path-from-shell
		      expand-region
		      monokai-theme
		      iedit
		      yang-mode
		      solarized-theme
		      use-package
		      ) "Default packages")

(defun my/packages-installed-p ()
  (loop for pkg in my/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))
(unless (my/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg my/packages)
    (when (not(package-installed-p pkg))
      (package-install pkg))))

(require 'use-package)
(add-to-list 'load-path "~/.emacs.d/lisp/auto-save/")
(require 'auto-save)
(auto-save-mode t)
(setq auto-save-silent t)
(setq auto-save-delete-trailing-whitespace t)
(auto-save-enable)
(use-package auto-compile
  :defer t
  :config (auto-compile-on-load-mode))
(use-package avy
  :defer 1
  :bind (("C-;" . avy-goto-char)))
(use-package expand-region
  :defer 1
  :bind (("C-=" . er/expand-region)))
(use-package posframe
  :load-path "~/.emacs.d/lisp/posframe/")
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t)
  (setq zenburn-override-colors-alist
      '(("zenburn-bg+05" . "#282828")
        ("zenburn-bg+1"  . "#2F2F2F")
        ("zenburn-bg+2"  . "#3F3F3F")
        ("zenburn-bg+3"  . "#4F4F4F"))))
(use-package ivy
  :defer 1
  :config
  (setq ivy-initial-inputs-alist nil
	ivy-wrap t
	ivy-height 15
	ivy-fixed-height-minibuffer t
	ivy-format-function #'ivy-format-function-line
	)
  (ivy-mode +1)
  :bind ([remap switch-to-buffer] . #'ivy-switch-buffer)
  )
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-medium t))
(use-package ivy-posframe
  :ensure t
  :after (ivy)
  :config
  (setq ivy-fixed-height-minibuffer nil
        ;; ivy-display-function #'ivy-posframe-display-at-point
        ivy-posframe-parameters
        `((min-width . 90)
          (min-height .,ivy-height)
          (internal-border-width . 10)))
  (push '(t . ivy-posframe-display-at-point) ivy-display-functions-alist)
  (push '(completion-at-point . ivy-posframe-display-at-point)
        ivy-display-functions-alist)
  (push '(complete-symbol . ivy-posframe-display-at-point) ivy-display-functions-alist)
  (push '(company-files . ivy-posframe-display-at-point) ivy-display-functions-alist)
  ;; posframe doesn't work well with async sources
  (push '(swiper . ivy-posframe-display-at-window-bottom-left)
        ivy-display-functions-alist)
  (ivy-posframe-enable))
(use-package flycheck
  :defer t
  :hook (prog-mode . flycheck-mode)
  )
(use-package flycheck-posframe
  :after flycheck
  :config (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))
(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (global-set-key [remap other-window] 'ace-window))

(use-package swiper
  :ensure t
  :config
  (global-set-key "\C-s" 'swiper))

(use-package counsel
  :defer 1
  :after (ivy)
  :bind (([remap execute-extended-command] . counsel-M-x)
     ([remap find-file]                . counsel-find-file)
     ([remap find-library]             . find-library)
     ([remap imenu]                    . counsel-imenu)
     ([remap recentf-open-files]       . counsel-recentf)
     ([remap org-capture]              . counsel-org-capture)
     ([remape swiper]                  . counsel-grep-or-swiper)
     ([remap describe-face]            . counsel-describe-face)
     ([remap describe-function]        . counsel-describe-function)
     ([remap describe-variable]        . counsel-describe-variable))

  :config
  (setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)"
    counsel-rg-base-command "rg -zS --no-heading --line-number --color never %s ."
    counsel-ag-base-command "ag -zS --nocolor --nogroup %s"
    counsel-pt-base-command "pt -zS --nocolor --nogroup -e %s")
  )
(use-package counsel-projectile
  :after projectile
  :commands (counsel-projectile-find-file counsel-projectile-find-dir counsel-projectile-switch-to-buffer
                                          counsel-projectile-grep counsel-projectile-ag counsel-projectile-switch-project)
  :init
  :bind (([remap projectile-find-file]        . counsel-projectile-find-file)
         ([remap projectile-find-dir]         . counsel-projectile-find-dir)
         ([remap projectile-switch-to-buffer] . counsel-projectile-switch-to-buffer)
         ([remap projectile-grep]             . counsel-projectile-grep)
         ([remap projectile-ag]               . counsel-projectile-ag)
         ([remap projectile-switch-project]   . counsel-projectile-switch-project)))

(use-package flx
  :defer t
  :init
  (setq ivy-re-builders-alist
	'((counsel-ag . ivy--regex-plus)
	  (counsel-grep . ivy--regex-plus)
	  (swiper . ivy--regex-plus)
	  (t . ivy--regex-fuzzy))
	ivy-initial-inputs-alist nil)
  )
(use-package helpful
  :defer 1
  :init
  (setq counsel-describe-function-function #'helpful-function
    counsel-describe-variable-function #'helpful-variable)
  :bind (([remap describe-key] . helpful-key))
  )

(use-package rainbow-delimiters
  :ensure t
  :init
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))
(use-package which-key
  :defer 1
  :init
  (setq which-key-sort-order #'which-key-prefix-then-key-order
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10)
  :config
  (which-key-mode +1)
  )


(use-package company
  :init
  (setq company-idle-delay 0
	company-tooltip-limit 10
	company-minimum-prefix-length 2
	company-dabbrev-downcase nil
	company-dabbrev-ignore-case nil
	company-dabbrev-code-other-buffers t
	company-tooltip-align-annotations t
	company-require-match 'never
	company-show-numbers t
	company-global-modes
	'(not comint-mode erc-mode message-mode help-mode gud-mode)
	company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend)
	company-backends '((:separate company-capf company-yasnippet company-files)))
  :config
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "C-s") #'company-filter-candidates)
  (global-company-mode +1))


(use-package company-posframe
  :if (display-graphic-p)
  :after company
  :hook (company-mode . company-posframe-mode))

(defconst mage-cache-dir "~/.local/cache/")
(use-package projectile
  :defer 1
  :init
  (setq projectile-cache-file (concat mage-cache-dir "projectile.cache")
    projectile-enable-caching (not noninteractive)
    projectile-indexing-method 'alien
    projectile-known-projects-file (concat mage-cache-dir "projectile.projects")
    projectile-require-project-root t
    projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
    projectile-ignored-projects '("~/" "/tmp" "/usr/include"))
  :config
  (projectile-mode +1)
  )
(use-package elpy
  :ensure t
  :init
  (setq elpy-rpc-backend "jedi")
  (elpy-enable)
  :config
  (add-hook 'python-mode-hook 'elpy-mode)
  (use-package py-autopep8)
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  (setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "jupyter")
  (when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
  :bind
  (("M-*" . pop-tag-mark)))


(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))


(use-package ein
  :ensure t
  :config

  (setq ein:complete-on-dot -1)

  (cond
   ((eq system-type 'darwin) (setq ein:console-args '("--gui=osx" "--matplotlib=osx" "--colors=Linux")))
   ((eq system-type 'gnu/linux) (setq ein:console-args '("--gui=gtk3" "--matplotlib=gtk3" "--colors=Linux"))))

  (setq ein:query-timeout 1000)

  (defun load-ein ()
    (ein:notebooklist-load)
    (interactive)
    (ein:notebooklist-open)))


(use-package pyim
  :ensure nil
  :demand t
  :config
  (use-package posframe)
  ;; 激活 basedict 拼音词库
  (use-package pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))

  ;; 五笔用户使用 wbdict 词库
  ;; (use-package pyim-wbdict
  ;;   :ensure nil
  ;;   :config (pyim-wbdict-gbk-enable))

  (setq default-input-method "pyim")

  ;; 我使用全拼
  (setq pyim-default-scheme 'quanpin)

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; 开启拼音搜索功能
  (pyim-isearch-mode 1)

  ;; 使用 pupup-el 来绘制选词框, 如果用 emacs26, 建议设置
  ;; 为 'posframe, 速度很快并且菜单不会变形，不过需要用户
  ;; 手动安装 posframe 包。
  ;;(setq pyim-page-tooltip 'popup)
  (setq pyim-page-tooltip 'posframe)

  ;; 选词框显示5个候选词
  (setq pyim-page-length 5)

  ;; 让 Emacs 启动时自动加载 pyim 词库
  (add-hook 'emacs-startup-hook
            #'(lambda () (pyim-restart-1 t)))
  :bind
  (("M-j" . pyim-convert-code-at-point) ;与 pyim-probe-dynamic-english 配合
   ("C-;" . pyim-delete-word-from-personal-buffer)))
(setq default-input-method "pyim")
(global-set-key (kbd "C-\\") 'toggle-input-method)
;;https://blog.csdn.net/xh_acmagic/article/details/78939246
(provide 'init-packages)
