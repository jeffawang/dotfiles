;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq projectile-completion-system 'default)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "jeff"
      user-mail-address "jeff@example.com")

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

(setq doom-font (font-spec :family "Source Code Pro" :size 12)
      doom-big-font (font-spec :family "Source Code Pro" :size 24)
      ;;doom-variable-pitch-font (font-spec :family "Overpass" :size 24)
                                        ;doom-unicode-font (font-spec :family "JuliaMono")
                                        ;doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light)
      )

;; Set the variable pitch face
(set-face-attribute 'default nil :font "Hack" :height 180)
(set-face-attribute 'variable-pitch nil :family "Cantarell")

(setq vc-gutter-in-margin t)
(setq vc-gutter-diff-unsaved-buffer t)

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


;; 
;; LANG
;;
(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook #'lsp-organize-imports)
  )
(setq exec-path (append exec-path '("/Users/jeffwang/.nvm/versions/node/v18.11.0/bin/")))
(add-to-list 'exec-path "~/.cargo/bin")

(map! :after lsp-mode
      :leader
      "c h" #'lsp-ui-doc-glance
      )

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]venv")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]fixtures")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]notification_snapshots")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]thirdparty")
  (setq lsp-file-watch-threshold 1000)
  )

;; svelte support
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))
(setq web-mode-engines-alist
      '(("svelte" . "\\.svelte\\'")))

(setq-hook! 'js-mode-hook +format-with-lsp nil) (setq-hook! 'js-mode-hook +format-with :none) (add-hook 'js-mode-hook 'prettier-js-mode)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  )
(add-hook 'web-mode-hook  'my-web-mode-hook)


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

(map! :n "z r" #'evil-open-folds)

;;; :ui
(map! (:when (modulep! :ui workspaces)
        (:when (featurep :system 'macos)
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
          :g "s-(" (lambda () (interactive)(evil-window-exchange -1))
          :g "s-)" #'evil-window-exchange
          :g "s-t" #'+workspace/new
          :g "s-T" #'vterm
          :g "s-b" #'window-toggle-side-windows
          :g "s-." #'lsp-execute-code-action
          :g "s-'" (lambda () (interactive) (org-refile '(4)))
          )))

;;; :org bindings
(map! (:when (featurep :system 'macos)
        :n "s-p" #'org-roam-node-find
        :after evil-org
        :map evil-org-mode-map
        :g "s-e" #'org-toggle-link-display
        :g "s-u" #'org-insert-link
        :g "s-U" #'org-cliplink
        :n "g l" #'org-down-element
        ;; Sort todos by org status order
        :g "s-i" (lambda () (interactive) (org-sort-entries nil ?o nil nil nil nil))
        ;; Interactively choose which key to sort by
        :g "s-I" #'org-sort-entries
        ))

(map! :leader
      :g "z z" #'zoom-window-zoom
      :n ">" #'projectile-find-file-in-directory
      )

(setq prettier-js-args '(
                         "--tab-width" "2"
                         ))

(custom-set-variables
 '(zoom-window-mode-line-color "DarkGreen"))

;; org stuff
(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("!!!" "!!" "!" "D")))

(add-hook 'org-mode-hook 'variable-pitch-mode)

(custom-set-variables '(org-directory "~/files/org") )

(after! org
  (setq org-roam-directory "~/files/org/roam") (setq org-roam-index-file "~/files/org/roam/index.org")
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
          )
        )

  (setq org-agenda-files '("~/files/org/roam/" "~/files/org/" "~/files/org/roam/daily/" "~/.emacs.d"))
  (setq
   ;;org-bullets-bullet-list '("·")
   org-superstar-headline-bullets-list '("⁖")
   org-ellipsis " ▾ "
   )

  ;; https://github.com/zaiste/.doom.d/blob/309515418eca591ed07a1d5f3cdf6710f712ec03/config.el
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

;; Log the done completion time when a thing is marked as done.
(setq org-log-done 'time)

;; Fix the special character mac input thing
(custom-set-variables
 '(mac-right-option-modifier 'meta))

;; Configure fill width
(setq visual-fill-column-width 80
      visual-fill-column-center-text t)

;; org-present
(defun my/org-present-prepare-slide (buffer-name heading)
  ;; Show only top-level headlines
  (org-overview)
  ;; Unfold the current entry
  (org-show-entry)
  ;; Show only direct subheadings of the slide but don't expand them
  (org-show-children))

(defun my/org-present-start ()
  (display-line-numbers-mode 0)
  (hide-mode-line-mode 1)
  ;; Tweak font sizes
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.0) variable-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
                                     (org-code (:height 1.55) org-code)
                                     (org-verbatim (:height 1.55) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))

  ;; Set a blank header line string to create blank space at the top
  (setq header-line-format " ")

  ;; Display inline images automatically
  (org-display-inline-images)

  ;; Center the presentation and wrap lines
  (visual-fill-column-mode 1)
  (visual-line-mode 1))

(defun my/org-present-end ()
  (display-line-numbers-mode 1)
  (hide-mode-line-mode 0)
  ;; Reset font customizations
  (setq-local face-remapping-alist '((default variable-pitch default)))

  ;; Clear the header line string so that it isn't displayed
  (setq header-line-format nil)

  ;; Stop displaying inline images
  (org-remove-inline-images)

  ;; Stop centering the document
  (visual-fill-column-mode 0)
  (visual-line-mode 0))

;; Register hooks with org-present
(add-hook 'org-present-mode-hook 'my/org-present-start)
(add-hook 'org-present-mode-quit-hook 'my/org-present-end)
(add-hook 'org-present-after-navigate-functions 'my/org-present-prepare-slide)

(setq org-refile-use-outline-path 'title)
(defun org-refile-get-targets (&optional default-buffer)
  "Produce a table with refile targets."
  (let ((case-fold-search nil)
	;; otherwise org confuses "TODO" as a kw and "Todo" as a word
	(entries (or org-refile-targets '((nil . (:level . 1)))))
	targets tgs files desc descre)
    (message "Getting targets...")
    (with-current-buffer (or default-buffer (current-buffer))
      (dolist (entry entries)
	(setq files (car entry) desc (cdr entry))
	(cond
	 ((null files) (setq files (list (current-buffer))))
	 ((eq files 'org-agenda-files)
	  (setq files (org-agenda-files 'unrestricted)))
	 ((and (symbolp files) (fboundp files))
	  (setq files (funcall files)))
	 ((and (symbolp files) (boundp files))
	  (setq files (symbol-value files))))
	(when (stringp files) (setq files (list files)))
	(cond
	 ((eq (car desc) :tag)
	  (setq descre (concat "^\\*+[ \t]+.*?:" (regexp-quote (cdr desc)) ":")))
	 ((eq (car desc) :todo)
	  (setq descre (concat "^\\*+[ \t]+" (regexp-quote (cdr desc)) "[ \t]")))
	 ((eq (car desc) :regexp)
	  (setq descre (cdr desc)))
	 ((eq (car desc) :level)
	  (setq descre (concat "^\\*\\{" (number-to-string
					  (if org-odd-levels-only
					      (1- (* 2 (cdr desc)))
					    (cdr desc)))
			       "\\}[ \t]")))
	 ((eq (car desc) :maxlevel)
	  (setq descre (concat "^\\*\\{1," (number-to-string
					    (if org-odd-levels-only
						(1- (* 2 (cdr desc)))
					      (cdr desc)))
			       "\\}[ \t]")))
	 (t (error "Bad refiling target description %s" desc)))
	(dolist (f files)
	  (with-current-buffer (if (bufferp f) f (org-get-agenda-file-buffer f))
	    (or
	     (setq tgs (org-refile-cache-get (buffer-file-name) descre))
	     (progn
	       (when (bufferp f)
		 (setq f (buffer-file-name (buffer-base-buffer f))))
	       (setq f (and f (expand-file-name f)))
	       (when (eq org-refile-use-outline-path 'file)
		 (push (list (and f (file-name-nondirectory f)) f nil nil) tgs))
	       (when (eq org-refile-use-outline-path 'buffer-name)
		 (push (list (buffer-name (buffer-base-buffer)) f nil nil) tgs))
	       (when (eq org-refile-use-outline-path 'full-file-path)
		 (push (list (and (buffer-file-name (buffer-base-buffer))
                                  (file-truename (buffer-file-name (buffer-base-buffer))))
                             f nil nil) tgs))
               (when (eq org-refile-use-outline-path 'title)
                 (push (list (or (org-get-title)
                                 (and f (file-name-nondirectory f)))
                             f nil nil)
                       tgs))
	       (org-with-wide-buffer
		(goto-char (point-min))
		(setq org-outline-path-cache nil)
		(while (re-search-forward descre nil t)
		  (beginning-of-line)
		  (let ((case-fold-search nil))
		    (looking-at org-complex-heading-regexp))
		  (let ((begin (point))
			(heading (match-string-no-properties 4)))
		    (unless (or (and
				 org-refile-target-verify-function
				 (not
				  (funcall org-refile-target-verify-function)))
				(not heading))
		      (let ((re (format org-complex-heading-regexp-format
					(regexp-quote heading)))
			    (target
			     (if (not org-refile-use-outline-path) heading
			       (mapconcat
				#'identity
				(append
				 (pcase org-refile-use-outline-path
				   (`file (list
                                           (and (buffer-file-name (buffer-base-buffer))
                                                (file-name-nondirectory
                                                 (buffer-file-name (buffer-base-buffer))))))
                                   (`title (list
                                            (or (org-get-title)
                                                (and (buffer-file-name (buffer-base-buffer))
                                                     (file-name-nondirectory
                                                      (buffer-file-name (buffer-base-buffer)))))))
                                   (`full-file-path
				    (list (buffer-file-name
					   (buffer-base-buffer))))
				   (`buffer-name
				    (list (buffer-name
					   (buffer-base-buffer))))
				   (_ nil))
				 (let ((x (mapcar (lambda (s) (replace-regexp-in-string
						               "/" "\\/" s nil t))
					          (org-get-outline-path t t))))
                                   (append
                                    (butlast x)
                                    (mapcar #'(lambda (s) (propertize s 'face 'embark-keybinding)) (last x)))
                                   ))
				"/"))))
			(push (list target f re (org-refile-marker (point)))
			      tgs)))
		    (when (= (point) begin)
		      ;; Verification function has not moved point.
		      (end-of-line)))))))
	    (when org-refile-use-cache
	      (org-refile-cache-put tgs (buffer-file-name) descre))
	    (setq targets (append tgs targets))))))
    (message "Getting targets...done")
    (delete-dups (nreverse targets))))

(map!
 :leader
 :prefix "j"
 "g" #'org-capture-goto-target
 "a" #'org-capture
 )

(setq org-agenda-include-diary t)

(setq org-agenda-custom-commands
      (quote (("n" "Agenda and all TODOs"
               ((agenda "" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline))))
                (alltodo "" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled)))
                         )
                ;; (tags "CLOSED<=\"<now>\"")
                )))))

(map!
 :after evil-org
 :g "s-;" (lambda () (interactive) (org-agenda nil "n"))
 :g "s-:" #'org-agenda
 )


;;
;; debugging
;; 
(map! :after dap-mode
      :n "SPC d d" #'dap-debug-last
      :n "SPC d D" #'dap-debug
      :n "SPC d c" #'dap-continue
      :n "SPC d n" #'dap-next
      :n "SPC d u" #'dap-up-stack-frame
      :n "SPC d i" #'dap-step-in
      :n "SPC d o" #'dap-step-out
      :n "SPC d s" #'dap-switch-stack-frame
      :n "SPC d q" #'dap-delete-session
      :n "SPC d b" #'dap-breakpoint-toggle
      :n "SPC d B" #'dap-breakpoint-condition
      :n "SPC d l" #'dap-breakpoint-log-message
      :n "SPC m x" #'dap-hydra
      :n "SPC m d" #'dap-hydra
      :n "<f8>" #'dap-hydra)

(after! dap-mode
  (after! dap-mode
    (require 'dap-cpptools)
    (require 'dap-gdb-lldb)
    (require 'dap-codelldb)
    ;; added b/c debug output popup was appearing to the right instead of below
    (set-popup-rule! "^.*LLDB" :side 'bottom))

  (after! lsp-mode
    (setq lsp-auto-register-remote-clients nil)
    (add-hook 'rustic-mode-hook (lambda ()
                                  (dap-register-debug-template
                                   "LLDB::Run Rust"
                                   (list :type "lldb"
                                         :request "launch"
                                         :name "LLDB::Run"
                                         ;; TODO: figure out how to get the freaking path set properly
                                         :miDebuggerPath "~/.cargo/bin/rust-lldb"
                                         :target nil
                                         :cwd (projectile-project-root)
                                         :program (concat (projectile-project-root) "target/debug/" (projectile-project-name)) ;; Requires that the rust project is a project in projectile
                                         :cleanup-function (lambda (sesh) (kill-buffer (dap--debug-session-output-buffer sesh)))
                                         ;; :cleanup-function (lambda (sesh)
                                         ;;                     (when (not (dap--session-running sesh))
                                         ;;                       (kill-buffer (dap--debug-session-output-buffer sesh))))
                                         ))
                                  )))
  )


;; (after! dap-mode
;;   (setq dap-auto-configure-features '(breakpoints sessions locals tooltip)))
;; (setq dap-auto-configure-features '(sessions locals breakpoints expressions controls tooltip)))

;; ;; dap (debugging)
;; (after! dap-mode
;;   (setq dap-auto-configure-features `(sessions locals tooltip))
;;   (setq lsp-enable-dap-auto-configure nil)
;;   )
;; (setq dap-auto-configure-features '(sessions locals controls tooltip))
;; (setq lsp-enable-dap-auto-configure nil)

(after! persp-mode
  ;; alternative, non-fancy version which only centers the output of +workspace--tabline
  (defun workspaces-formatted ()
    (concat (+workspace--tabline)))

  (defun hy/invisible-current-workspace ()
    "The tab bar doesn't update when only faces change (i.e. the
current workspace), so we invisibly print the current workspace
name as well to trigger updates"
    (propertize (safe-persp-name (get-current-persp)) 'invisible t))

  (customize-set-variable 'tab-bar-format '(workspaces-formatted tab-bar-format-align-right hy/invisible-current-workspace))

  ;; don't show current workspaces when we switch, since we always see them
  (advice-add #'+workspace/display :override #'ignore)
  ;; same for renaming and deleting (and saving, but oh well)
  (advice-add #'+workspace-message :override #'ignore))

;; need to run this later for it to not break frame size for some reason
(run-at-time nil nil (cmd! (tab-bar-mode +1)))

(use-package! astro-ts-mode
  :after treesit-auto
  :init
  (when (modulep! +lsp)
    (add-hook 'astro-ts-mode-hook #'lsp! 'append))
  :config
  (global-treesit-auto-mode)
  (let ((astro-recipe (make-treesit-auto-recipe
                       :lang 'astro
                       :ts-mode 'astro-ls-mode
                       :url "https://github.com/virchau13/tree-sitter-astro"
                       :revision "master"
                       :source-dir "src")))
    (add-to-list 'treesit-auto-recipe-list astro-recipe))
  :after treesit-auto
  )
