;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook #'lsp-organize-imports)
)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



;; function for when too many files are oppen (lol emacs)
(defun file-notify-rm-all-watches ()
  "Remove all existing file notification watches from Emacs."
  (interactive)
  (maphash
   (lambda (key _value)
     (file-notify-rm-watch key))
   file-notify-descriptors))

;; debugging
(map! :after dap-mode
      :n "SPC m x" #'dap-hydra
      :n "SPC m d" #'dap-hydra
      :n "<f8>" #'dap-hydra)

;;; :ui
(map! (:when (featurep! :ui workspaces)
        (:when IS-MAC
          :g "s-J" #'+workspace/switch-right
          :g "s-K" #'+workspace/switch-left
          :g "s-}" #'+workspace/switch-right
          :g "s-{" #'+workspace/switch-left
          :g "s-j" #'evil-window-next
          :g "s-k" #'evil-window-prev
          :g "s-]" #'evil-window-next
          :g "s-[" #'evil-window-prev
          :g "s-|" #'+evil/window-vsplit-and-follow
          :g "s-_" #'+evil/window-split-and-follow
          :g "s->" #'+evil-window-increase-width
          :g "s-<" #'+evil-window-decrease-width
          :g "s-(" #'evil-window-exchange
          :g "s-)" #'evil-window-exchange
          :g "s-)" #'evil-window-split
          :g "s-t" #'+workspace/new
          :g "s-T" #'vterm
          :g "s-b" #'window-toggle-side-windows
          :g "s-." #'lsp-execute-code-action
          )))

;;; :org bindings
(map! (:when IS-MAC
        :n "s-p" #'org-roam-node-find
        :after evil-org
        :map evil-org-mode-map
        :g "s-e" #'org-toggle-link-display
        :g "s-u" #'org-insert-link
        :g "s-U" #'org-cliplink
        :n "g l" #'org-down-element
        ))

;; Set the variable pitch face
(set-face-attribute 'default nil :font "Hack" :height 180)
(set-face-attribute 'variable-pitch nil :family "Cantarell")

  ;; https://zzamboni.org/post/beautifying-org-mode-in-emacs/
  (custom-theme-set-faces
   'user
   '(org-todo ((t (:inherit fixed-pitch))))
   '(org-date ((t (:inherit fixed-pitch))))
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   ;; '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
   '(line-number ((t (:inherit fixed-pitch))))
   '(line-number-current-line ((t (:inherit fixed-pitch)))))

(after! org
  (setq org-roam-directory "~/files/org/roam") (setq org-roam-index-file "~/files/org/roam/index.org")
  )

(add-hook 'org-mode-hook 'variable-pitch-mode)

(setq exec-path (append exec-path '("/Users/jeffwang/.nvm/versions/node/v18.11.0/bin/")))

(custom-set-variables '(org-directory "~/files/org") )

(after! org
  (setq org-todo-keywords
        '(
          ;; todo, in progress, blocked | done, canceled
          (sequence "[ ](t)" "[-](i)" "[.](b)" "[?](q)" "|" "[x](x)" "[c](c)")
          ;; (sequence "TODO(T)" "INPROGRESS(I)" "WAITING(W)" "|" "DONE(X)")
          ))
  (setq org-todo-keyword-faces
        '(
          ("[-]" . +org-todo-active)
          ("[.]" . +org-todo-cancel)
          ("[?]" . +org-todo-cancel)
          ))

  (setq org-agenda-files '("~/files/org/roam/" "~/files/org/" "~/files/org/roam/daily/" "~/.emacs.d"))
  (setq ;;org-bullets-bullet-list '("·")
   org-superstar-headline-bullets-list '("⁖")
   org-ellipsis " ▾ "
   )
  )

;; https://github.com/zaiste/.doom.d/blob/309515418eca591ed07a1d5f3cdf6710f712ec03/config.el

(after! org
  ;; (set-face-attribute 'org-link nil
  ;;                     :weight 'normal
  ;;                     :background nil)
  ;; (set-face-attribute 'org-code nil
  ;;                     :foreground "#a9a1e1"
  ;;                     :background nil)
  ;; (set-face-attribute 'org-date nil
  ;;                     :foreground "#5B6268"
  ;;                     :background nil)
  (set-face-attribute 'org-level-1 nil
                      :foreground "steelblue2"
                      :background nil
                      :height 1.2
                      :weight 'normal)
  (set-face-attribute 'org-level-2 nil
                      :foreground "SkyBlue2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-3 nil
                      :foreground "slategray2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-4 nil
                      :foreground "slategray2"
                      :weight 'normal)
  (set-face-attribute 'org-level-5 nil
                      :foreground "slategray2"
                      :weight 'normal)
  (set-face-attribute 'org-level-6 nil
                      :foreground "slategray2"
                      :weight 'normal)
  (set-face-attribute 'org-level-7 nil
                      :foreground "slategray2"
                      :weight 'normal)
  (set-face-attribute 'org-level-8 nil
                      :foreground "slategray2"
                      :weight 'normal)
  (set-face-attribute 'org-document-title nil
                      :foreground "SlateGray1"
                      :background nil
                      :height 1.5
                      :weight 'bold)
  )

(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("!!!" "!!" "!" "D")))

;; Log the done completion time when a thing is marked as done.
(setq org-log-done 'time)

;; Fix the special character mac input thing
(custom-set-variables
 '(mac-right-option-modifier 'meta))



(setq doom-font (font-spec :family "Source Code Pro" :size 12)
      doom-big-font (font-spec :family "Source Code Pro" :size 24)
      ;;doom-variable-pitch-font (font-spec :family "Overpass" :size 24)
                                        ;doom-unicode-font (font-spec :family "JuliaMono")
                                        ;doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light)
      )

;; ;; dap (debugging)
;; (after! dap-mode
;;   (setq dap-auto-configure-features `(sessions locals tooltip))
;;   (setq lsp-enable-dap-auto-configure nil)
;;   )
(setq dap-auto-configure-features '(sessions locals controls tooltip))
(setq lsp-enable-dap-auto-configure nil)

;; ;; ==========================================================
;; ;; Add org-roam stuff (eg. dailies) to org agenda
;; ;; https://org-roam.discourse.group/t/tips-dynamically-add-org-roam-files-to-your-agenda-file/1122/8

;; (defvar dynamic-agenda-files nil
;;   "dynamic generate agenda files list when changing org state")

;; (defun update-dynamic-agenda-hook ()
;;   (let ((done (or (not org-state) ;; nil when no TODO list
;;                   (member org-state org-done-keywords)))
;;         (file (buffer-file-name))
;;         (agenda (funcall (ad-get-orig-definition 'org-agenda-files)) ))
;;     (unless (member file agenda)
;;       (if done
;;           (save-excursion
;;             (goto-char (point-min))
;;             ;; Delete file from dynamic files when all TODO entry changed to DONE
;;             (unless (search-forward-regexp org-not-done-heading-regexp nil t)
;;               (customize-save-variable
;;                'dynamic-agenda-files
;;                (cl-delete-if (lambda (k) (string= k file))
;;                              dynamic-agenda-files))))
;;         ;; Add this file to dynamic agenda files
;;         (unless (member file dynamic-agenda-files)
;;           (customize-save-variable 'dynamic-agenda-files
;;                                    (add-to-list 'dynamic-agenda-files file)))))))

;; (defun dynamic-agenda-files-advice (orig-val)
;;   (cl-union orig-val dynamic-agenda-files :test #'equal))

;; (advice-add 'org-agenda-files :filter-return #'dynamic-agenda-files-advice)
;; (add-to-list 'org-after-todo-state-change-hook 'update-dynamic-agenda-hook t)
;; ;; ==========================================================


;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lisp . t) ;; Other languages
;;    (shell . t)
;;    ;; Python & Jupyter
;;    (python . t)
;;    (jupyter . t)))

;; (use-package! org-transclusion
;;   :after org
;;   :init
;;   (map!
;;    :map global-map "<f12>" #'org-transclusion-add
;;    :leader
;;    :prefix "n"
;;    :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))
