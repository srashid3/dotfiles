(setq backup-directory-alist '(("." . "~/.emacs-backups")))

(setq custom-file (concat user-emacs-directory "custom.el"))

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

(elpaca-wait)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-variables '("PATH"))
  (exec-path-from-shell-initialize))

(use-package vertico
  :custom
  (vertico-resize t)
  (vertico-cycle t)
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-S-s" . consult-line-multi)
         ("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line))
  :config
  (setq consult-goto-line-numbers nil))

(use-package embark
  :bind (("C-." . embark-act))
  :config
  (setq embark-mixed-indicator-delay 60))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(defvar-keymap srashid3/text-transform
  :doc "Keymap for text transformations."
  "e" #'base64-encode-region
  "d" #'base64-decode-region
  "j" #'json-pretty-print)

(add-to-list 'embark-keymap-alist '(region . srashid3/text-transform))

(use-package corfu
  :init (global-corfu-mode))

(use-package projectile
  :diminish projectile-mode
  :init (projectile-mode 1)
  :bind-keymap ("C-c p" . projectile-command-map)
  :custom
  (projectile-completion-system 'ivy)
  (projectile-project-search-path '("~/Github")))

(use-package counsel-projectile
  :init (counsel-projectile-mode 1))

(use-package magit)

(use-package transient)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(column-number-mode)

(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook
                eat-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(delete-selection-mode t)

(setq srashid3/font-height 180)

(set-face-attribute 'default nil :font "Menlo" :height srashid3/font-height)
(set-face-attribute 'fixed-pitch nil :font "Menlo" :height srashid3/font-height)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height srashid3/font-height :weight 'regular)

(use-package mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode))

(use-package nerd-icons)

(use-package diminish)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 25))

(use-package shrink-path
  :ensure (:host github :repo "https://github.com/zbelial/shrink-path.el"))

(use-package doom-themes
  :init (load-theme 'wombat t))

(use-package dashboard
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-file-icons t)
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-newline
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-init-info
                               dashboard-insert-items))
  (dashboard-items '((recents . 5)
                     (projects . 5)
                     (bookmarks . 5))))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-unset-key (kbd "C-h n"))

(global-set-key (kbd "C-c c") 'comint-clear-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)

(use-package which-key
  :diminish
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package hydra)
(elpaca-wait)

(defhydra hydra-scale-text (global-map "C-c t")
  "scale-text"
  ("j" text-scale-increase "increase")
  ("k" text-scale-decrease "decrease")
  ("f" nil "finished" :exit t))

(defhydra hydra-resize-border (global-map "C-c w")
  "resize-border"
  ("j" enlarge-window-horizontally "increase")
  ("k" shrink-window-horizontally "decrease")
  ("f" nil "finished" :exit t))

(use-package evil
  :init
  (setq evil-want-C-i-jump nil)
  (evil-mode 1)
  :config (evil-set-undo-system 'undo-redo))

(elpaca-wait)

(dolist (mode '(term-mode
                eshell-mode
                eat-mode
                dashboard-mode))
  (evil-set-initial-state mode 'emacs))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(define-key evil-normal-state-map (kbd "C-.") #'embark-act)
(define-key evil-visual-state-map (kbd "C-.") #'embark-act)

(defun srashid3/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :ensure nil
  :hook (org-mode . srashid3/org-mode-setup)
  :config
  (set-face-underline 'org-ellipsis nil)
  :custom
  (org-ellipsis " ▾")
  (org-startup-folded t)
  (org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun srashid3/org-mode-visual-column ()
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :ensure (:host github :repo "https://github.com/joostkremers/visual-fill-column")
  :hook (org-mode . srashid3/org-mode-visual-column))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(defun srashid3/org-flyspell-hook ()
  (let* ((flyspell-key (org-collect-keywords '("FLYSPELL")))
         (flyspell-val (car (last (car flyspell-key)))))
    (unless (and flyspell-key (not (intern flyspell-val)))
      (flyspell-mode 1))))

(use-package flyspell
  :ensure nil
  :hook (org-mode . srashid3/org-flyspell-hook)
  :custom (setq ispell-program-name "aspell"))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
         ("M-TAB" . flyspell-correct-wrapper)))

(use-package flyspell-correct-ivy
  :after flyspell-correct)

(org-babel-do-load-languages
'org-babel-load-languages
'((emacs-lisp . t)
  (shell . t)
  (python . t)))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("py" . "src python :results output"))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Github/org-notes"))
  (org-roam-capture-templates
   '(("m" "main" plain "%?"
    :if-new (file+head "main/${slug}.org" "#+title: ${title}\n#+filetags: :draft:\n")
    :unnarrowed t)))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-db-autosync-mode)
  (setq org-roam-dailies-directory "journal")
  (setq org-roam-node-display-template (concat "${title:40} " (propertize "${tags}" 'face 'marginalia-documentation))))

(defun srashid3/org-roam-abort (func &rest args)
  (message "Deleted file for aborted capture")
  t)

(defun srashid3/org-roam-capture (func &rest args)
  (advice-add 'yes-or-no-p :around #'srashid3/org-roam-abort)
  (let ((res (apply func args)))
    (advice-remove 'yes-or-no-p #'srashid3/org-roam-abort)
    res))

(advice-add 'org-roam-capture--finalize :around #'srashid3/org-roam-capture)

(use-package eat
  :ensure (:host github :repo "https://github.com/kephale/emacs-eat")
  :hook (eshell-mode . eat-eshell-mode))

(defun srashid3/eshell-aliases ()
  (eshell/alias "clear" "clear 1")
  (eshell/alias "venv" "python3 -m venv venv")
  (eshell/alias "activate" "pyvenv-activate venv")
  (eshell/alias "deactivate" "pyvenv-deactivate"))

(use-package eshell
  :ensure nil
  :after esh-mode
  :bind (:map eshell-mode-map
         ("C-r" . counsel-esh-history))
  :hook (eshell-mode . srashid3/eshell-aliases)
  :custom
  (eshell-hist-ignoredups t)
  (eshell-modify-global-environment t)
  (eshell-bad-command-tolerance 100))

(defun srashid3/eshell-reload-path ()
  (eshell-set-path (mapconcat 'identity exec-path ":")))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-headerline-breadcrumb-icons-enable nil)    
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui)

(use-package lsp-ivy
  :after lsp)

(use-package c-mode
  :ensure nil
  :hook (c-mode . lsp-deferred))

(setq-default c-default-style "linux" c-basic-offset 4)

(use-package python-mode
  :ensure (:host github :repo "https://github.com/emacsmirror/python-mode")
  :hook (python-mode . lsp-deferred))

(use-package pyvenv
  :init (pyvenv-mode 1))

(add-hook 'pyvenv-post-activate-hooks 'srashid3/eshell-reload-path)
(add-hook 'pyvenv-post-deactivate-hooks 'srashid3/eshell-reload-path)
