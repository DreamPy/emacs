
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

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
(provide 'init-ui)


					
