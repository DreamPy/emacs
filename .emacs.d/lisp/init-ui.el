
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
;; (display-time-mode 1)
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(global-linum-mode 1)
(global-hl-line-mode 1)
(setq cursor-type 'bar)

(setq inhibit-splash-screen 1)
(setq make-backup-file nil)

(set-face-attribute 'default nil :height 160)
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  )
(set-language-environment "UTF-8")
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

(delete-selection-mode 1)

;;set theme
(load-theme 'solarized-dark 1)
(global-auto-revert-mode t)
(setq auto-save-default nil)


(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)
;;(set-default-font "Source Code Pro")
(set-fontset-font "fontset-default" 'gb18030 '("Microsoft YaHei" . "unicode-bmp"))
(setq-default frame-title-format
              '(:eval
                (format "%s@%s: %s %s"
                        (or (file-remote-p default-directory 'user)
                            user-real-login-name)
                        (or (file-remote-p default-directory 'host)
                            system-name)
                        (buffer-name)
                        (cond
                         (buffer-file-truename
                          (concat "(" buffer-file-truename ")"))
                         (dired-directory
                          (concat "{" dired-directory "}"))
                         (t
                          "[no file]")))))
;;设置编辑环境
;; 设置为中文简体语言环境
(set-language-environment 'Chinese-GB)
;;设置emacs 使用 utf-8
(setq locale-coding-system 'utf-8)
;;设置键盘输入时的字符编码
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
;;文件默认保存为 utf-8
(set-buffer-file-coding-system 'utf-8)
(set-default buffer-file-coding-system 'utf8)
(set-default-coding-systems 'utf-8)
;;解决粘贴中文出现乱码的问题
(set-clipboard-coding-system 'gbk)
;;终端中文乱码
;;(set-terminal-coding-system 'gbk)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
;; 解决文件目录的中文名乱码
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
;; 解决 Shell Mode(cmd) 下中文乱码问题

(defun change-shell-mode-coding ()

  (progn
    (set-terminal-coding-system 'gbk)
    (set-keyboard-coding-system 'gbk)
    (set-selection-coding-system 'gbk)
    (set-buffer-file-coding-system 'gbk)
    (set-file-name-coding-system 'gbk)
    (modify-coding-system-alist 'process "*" 'gbk)
    (set-buffer-process-coding-system 'gbk 'gbk)

    (set-file-name-coding-system 'gbk)))

(provide 'init-ui)
