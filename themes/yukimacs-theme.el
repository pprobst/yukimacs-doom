;;; yukimacs-theme.el --- inspired by Tommorrow Night -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Added: May 17, 2023
;; Author: Pedro Probst <https://github.com/pprobst>
;; Maintainer: Pedro Probst <https://github.com/pprobst>
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup yukimacs-theme nil
  "Options for the `yukimacs' theme."
  :group 'doom-themes)

(defcustom yukimacs-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'yukimacs-theme
  :type 'boolean)

(defcustom yukimacs-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'yukimacs-theme
  :type 'boolean)

(defcustom yukimacs-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'yukimacs-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme yukimacs
  "A dark theme inspired by Tomorrow Night."

  ;; name        default   256           16
  ((bg         '("#000000" "black"       "black"  ))
   (fg         '("#ffffff" "#e9e9e9"     "brightwhite"  ))

   ;; These are off-color variants of bg/fg, used primarily for `solaire-mode',
   ;; but can also be useful as a basis for subtle highlights (e.g. for hl-line
   ;; or region), especially when paired with the `doom-darken', `doom-lighten',
   ;; and `doom-blend' helper functions.
   (bg-alt     '("#121212" "black"       "black"        ))
   (fg-alt     '("#d4d4d4" "#2d2d2d"     "white"        ))

   ;; These should represent a spectrum from bg to fg, where base0 is a starker
   ;; bg and base8 is a starker fg. For example, if bg is light grey and fg is
   ;; dark grey, base0 should be white and base8 should be black.
   (base0      '("#000000" "black"       "black"        ))
   (base1      '("#0a0a0a" "#0a0a0a"     "brightblack"  ))
   (base2      '("#131313" "#141414"     "brightblack"  ))
   (base3      '("#171717" "#1a1a1a"     "brightblack"  ))
   (base4      '("#757575" "#3f3f3f"     "brightblack"  ))
   (base5      '("#949494" "#525252"     "brightblack"  ))
   (base6      '("#b5b5b5" "#6b6b6b"     "brightblack"  ))
   (base7      '("#dfdfdf" "#979797"     "brightblack"  ))
   (base8      '("#FFFFFF" "#ffffff"     "white"        ))

   (grey       base4)
   (red        '("#AA5544" "#B43A21" "red"          ))
   (orange     '("#de935f" "#c98352" "brightred"    ))
   (green      '("#6A9B88" "#6A9B76" "green"        ))
   (teal       '("#4db5bd" "#44b9b1" "brightgreen"  ))
   (yellow     '("#f0c674" "#ECBE7B" "yellow"       ))
   (blue       '("#6D9AC5" "#6d88c5" "brightblue"   ))
   (dark-blue  '("#3b6c90" "#3b6390" "blue"         ))
   (violet    '("#794d88" "#884d82" "brightmagenta"))
   (magenta     '("#B68BC4" "#c48bc1" "magenta"      ))
   (cyan       '("#6A8F9B" "#6db1bb" "brightcyan"   ))
   (dark-cyan  '("#407a83" "#408382" "cyan"         ))

   ;; These are the "universal syntax classes" that doom-themes establishes.
   ;; These *must* be included in every doom themes, or your theme will throw an
   ;; error, as they are used in the base theme defined in doom-themes-base.
   (highlight      blue)
   (vertical-bar   (doom-darken base1 0.1))
   (selection      dark-blue)
   (builtin        yellow)
   (comments       (if yukimacs-brighter-comments dark-cyan base5))
   (doc-comments   (doom-lighten (if yukimacs-brighter-comments dark-cyan base5) 0.25))
   (constants      violet)
   (functions      blue)
   (keywords       magenta)
   (methods        cyan)
   (operators      blue)
   (type           yellow)
   (strings        green)
   (variables      (doom-lighten red 0.1))
   (numbers        orange)
   (region         `(,(doom-lighten (car bg-alt) 0.15) ,@(doom-lighten (cdr base1) 0.35)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; These are extra color variables used only in this theme; i.e. they aren't
   ;; mandatory for derived themes.
   (modeline-fg              fg)
   (modeline-fg-alt          base5)
   (modeline-bg              (if yukimacs-brighter-modeline
                                 (doom-darken blue 0.45)
                               (doom-darken bg-alt 0.1)))
   (modeline-bg-alt          (if yukimacs-brighter-modeline
                                 (doom-darken blue 0.475)
                               `(,(doom-darken (car bg-alt) 0.15) ,@(cdr bg))))
   (modeline-bg-inactive     `(,(car bg-alt) ,@(cdr base1)))
   (modeline-bg-inactive-alt `(,(doom-darken (car bg-alt) 0.1) ,@(cdr bg)))

   (-modeline-pad
    (when yukimacs-padded-modeline
      (if (integerp yukimacs-padded-modeline) yukimacs-padded-modeline 4))))


  ;;;; Base theme face overrides
  (((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   ((font-lock-comment-face &override)
    :background (if yukimacs-brighter-comments (doom-lighten bg 0.05)))
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if yukimacs-brighter-modeline base8 highlight))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if yukimacs-brighter-modeline modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")
   ;;;; ivy
   (ivy-current-match :background dark-blue :distant-foreground base0 :weight 'normal)
   ;;;; LaTeX-mode
   (font-latex-math-face :foreground green)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))
   ;;;; rjsx-mode
   (rjsx-tag :foreground red)
   (rjsx-attr :foreground orange)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt))))

  ;;;; Base theme variable overrides-
  ())

;;; yukimacs-theme.el ends here
