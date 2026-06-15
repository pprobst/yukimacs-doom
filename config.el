(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell "/usr/bin/fish")
(setq-default explicit-shell-file-name "/usr/bin/fish")

;(setq user-full-name "pprobst"
;      user-mail-address "pprobst@insiberia.net")

(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "Aporetic Sans Mono" :size 15)
      doom-big-font (font-spec :family "Aporetic Sans Mono" :size 20))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
    '(font-lock-comment-face :slant italic)
    '(font-lock-keyword-face :slant italic))

;; Some dark themes
;;(setq doom-theme 'yukimacs)
;;(setq doom-theme 'modus-vivendi-tinted)
;;(setq doom-theme 'modus-vivendi)
;;(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-gruvbox)
;;(setq doom-theme 'doom-tomorrow-night)
(setq doom-theme 'doom-tokyo-night)

;; Some light themes
;;(setq doom-theme 'modus-operandi)
;;(setq doom-theme 'modus-operandi-tinted)
;;(setq doom-theme 'doom-one-light)
;;(setq doom-theme 'doom-gruvbox-light)
;;(setq doom-theme 'doom-tomorrow-day)

(setq fancy-splash-image "~/.config/doom/banners/yukimacs-logo-classic-smaller.png")

(use-package! indent-bars
  :hook ((prog-mode) . indent-bars-mode)) ; or whichever modes you prefer
(setq
    indent-bars-color '(highlight :face-bg t :blend 0.15)
    indent-bars-pattern "."
    indent-bars-width-frac 0.5
    indent-bars-pad-frac 0.25
    indent-bars-zigzag nil
    indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1) ; blend=1: blend with BG only
    indent-bars-highlight-current-depth '(:blend 0.5) ; pump up the BG blend on current
    indent-bars-display-on-blank-lines t)

;; For relative line numbers, set this to `relative`.
(setq display-line-numbers-type t)

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Edit doom config.org"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit doom init.el"     "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))

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

(setq lsp-lens-enable nil)

(setq dired-open-extensions '(("jpg" . "nsxiv")
                              ("png" . "nsxiv")
                              ("mkv" . "mpv")
                              ("mp3" . "mpv")
                              ("mp4" . "mpv")))

(custom-set-faces!
    '(org-level-1 :inherit outline-1 :height 1.3)
    '(org-level-2 :inherit outline-2 :height 1.2)
    '(org-level-3 :inherit outline-3 :height 1.1)
    '(org-level-4 :inherit outline-4 :height 1.0)
    '(org-level-5 :inherit outline-5 :height 1.0))

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
        :if-new (file+head "%<%Y-%m-%d-%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: project")
        :unnarrowed t)))
    (org-roam-dailies-capture-templates
        '(("d" "default daily" entry
        "* %<%H:%M> %?"
        :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d %A>\n#+filetags: daily"))
        ("t" "task" entry
        "* TODO %?"
        :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d %A>\n#+filetags: daily")
        :unnarrowed t)))
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

(defun bms/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep "rg --null --multiline --ignore-case --type org --line-buffered --color=always --max-columns=500 --no-heading --line-number . -e ARG OPTS"))
    (consult-ripgrep org-roam-directory)))
(global-set-key (kbd "C-c rr") 'bms/org-roam-rg-search)

(beacon-mode 1)

(use-package! treemacs
:config
(setq treemacs-width 30)
:bind (:map global-map
    ("C-x t t" . treemacs)
    ("C-x t 1" . treemacs-select-window)))

(setq-default history-length 1000)

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

(setq imenu-list-focus-after-activation t)
(map! :leader
      (:prefix ("t" . "Toggle")
       :desc "Toggle imenu shown in a sidebar" "i" #'imenu-list-smart-toggle))

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(set-formatter! 'ruff :modes '(python-mode python-ts-mode))

;; Change file viewer.
(setq +latex-viewers '(zathura))

;; Using cdlatex’s snippets despite having yasnippet.
(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)

(setq lsp-pyright-langserver-command "basedpyright")
