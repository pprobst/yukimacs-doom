;(setq user-full-name "pprobst"
;      user-mail-address "pprobst@insiberia.net")

(setq doom-font (font-spec :family "Iosevka Comfy" :size 16)
      doom-variable-pitch-font (font-spec :family "Iosevka Comfy Duo" :size 16)
      doom-big-font (font-spec :family "Iosevka Comfy" :size 20))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
    '(font-lock-comment-face :slant italic)
    '(font-lock-keyword-face :slant italic))

(setq doom-theme 'modus-operandi)
;;(setq doom-theme 'yukimacs)

;; For relative line numbers, set this to `relative`.
(setq display-line-numbers-type t)

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Edit doom config.org"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit doom init.el"     "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))

(show-paren-mode 1)

(defun split-and-follow-horizontally ()
    (interactive)
    (split-window-below)
    (balance-windows)
    (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
    (interactive)
    (split-window-right)
    (balance-windows)
    (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defun solaire-mode-real-buffer-custom-p ()
  "Return t if the current buffer is the dashboard or scratch, or is a real (file-visiting) buffer."
  (cond ((string= (buffer-name (buffer-base-buffer)) "*dashboard*") t)
        ((string= (buffer-name (buffer-base-buffer)) "*scratch*") t)
        ((buffer-file-name (buffer-base-buffer)) t)
        (t nil)))
(after! solaire-mode
  (setq solaire-mode-real-buffer-fn #'solaire-mode-real-buffer-custom-p))

(setq dired-open-extensions '(("jpg" . "nsxiv")
                              ("png" . "nsxiv")
                              ("mkv" . "mpv")
                              ("mp3" . "mpv")
                              ("mp4" . "mpv")))

(custom-set-faces
    '(org-level-1 ((t (:inherit outline-1 :height 1.3))))
    '(org-level-2 ((t (:inherit outline-2 :height 1.2))))
    '(org-level-3 ((t (:inherit outline-3 :height 1.1))))
    '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
    '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

(use-package! org-roam
:custom
(org-roam-directory "~/Notes")
(org-roam-completion-everywhere t)
(org-roam-capture-templates
    ;; "d" is the letter you'll press to choose the template.
    ;; "default" is the full name of the template.
    ;; plain is the type of text being inserted.
    ;; "%?" is the text that will be inserted.
    ;; unnarrowed t ensures that the full file will be displayed when captured.
    '(("d" "default" plain "%?"
        :if-new (file+head "%<%Y-%m-%d-%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
        :unnarrowed t)
    ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
        :if-new (file+head "%<%Y-%m-%d-%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
        :unnarrowed t)))
(org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%H:%M>: %?"
        :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
:bind (("C-c n l" . org-roam-buffer-toggle)
        ("C-c n f" . org-roam-node-find)
        ("C-c n i" . org-roam-node-insert)
        ("C-c n t" . org-roam-tag-add)
        ("C-c n a" . org-roam-alias-add)
        ("C-c n o" . org-id-get-create)
        :map org-mode-map
        ("C-M-i" . completion-at-point)
        :map org-roam-dailies-map
        ("Y" . org-roam-dailies-capture-yesterday)
        ("T" . org-roam-dailies-capture-tomorrow))
:bind-keymap
("C-c n d" . org-roam-dailies-map)
:config
(org-roam-setup)
(require 'org-roam-dailies) ;; Ensure the keymap is available
(org-roam-db-autosync-mode))

(beacon-mode 1)

(use-package! treemacs
:config
(setq treemacs-width 30)
:bind (:map global-map
    ("C-x t t" . treemacs)
    ("C-x t 1" . treemacs-select-window)))

(use-package! dashboard
:preface
(defun create-scratch-buffer ()
    "Create a scratch buffer"
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))
:config
(dashboard-setup-startup-hook)
(dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
;(setq dashboard-banner-logo-title "Y U K I M A C S")
(setq dashboard-banner-logo-title "\n")
(setq dashboard-startup-banner "~/.config/doom/banners/yukimacs-logo-classic-alt.png")
(setq dashboard-center-content t)
;(setq dashboard-init-info (format "Loaded in %s" (emacs-init-time)))
;(setq dashboard-set-footer nil)
(setq dashboard-footer-messages '("\"It's a Wonderful Everyday!\""))
(setq dashboard-footer-icon "")
(setq dashboard-set-navigator t)
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)))
(setq dashboard-navigator-buttons
        `(;; line1
        ((,nil
            "Yukimacs on GitHub"
            "Open yukimacs' GitHub on your browser"
            (lambda (&rest _) (browse-url "https://github.com/pprobst/yukimacs-doom"))
            'default)
            (,nil
            "Open scratch buffer"
            "Switch to the scratch buffer"
            (lambda (&rest _) (create-scratch-buffer))
            'default)
            (nil
            "Open config.org"
            "Open yukimacs' config file for easy editing"
              (lambda (&rest _) (find-file "~/.config/doom/config.org"))
              'default)))))
  ;; With Emacs as daemon mode, when running `emacsclient`, open *dashboard* instead of *scratch*.
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
(setq doom-fallback-buffer-name "*dashboard*")

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort))

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(use-package! aas
  :commands aas-mode)

;; Same as above but specifically for LaTeX.
(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :config
  (defun laas-tex-fold-maybe ()
    (unless (equal "/" aas-transient-snippet-key)
      (+latex-fold-last-macro-a)))
  (add-hook 'aas-post-snippet-expand-hook #'laas-tex-fold-maybe))

(setq yas-triggers-in-field t)

(use-package! keycast
  :after doom-modeline
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast--update t)
          (add-to-list 'global-mode-string '("" keycast-mode-line " ")))
      (remove-hook 'pre-command-hook 'keycast--update)
      (setq global-mode-string (remove '("" keycast-mode-line " ") global-mode-string))))
  (keycast-mode))

(setq +latex-viewers '(zathura))
