;; Emacs Version >= 27

;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Auto Save Directory
(setq backup-directory-alist '(("." . "~/.emacs-backups")))

;; Line Numbers
(global-display-line-numbers-mode t)

(defun disable-line-numbers-hook ()
  (display-line-numbers-mode 0))

(add-hook 'eshell-mode-hook 'disable-line-numbers-hook)

;; Cursor Position
(setq line-number-mode t)
(setq column-number-mode t)

;; Tab Format
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Delete Selection
(delete-selection-mode t)

;; Parenthesis Matching
(show-paren-mode 0)

;; Tab Bar
(setq tab-bar-show 1)
(setq tab-bar-separator " | ")
(setq tab-bar-new-tab-choice "New Tab")
(setq tab-bar-close-button-show nil)
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
(tab-bar-mode t)

;; CC Mode
(setq-default c-default-style "linux" c-basic-offset 4)

;; Custom Packages
(custom-set-variables
  '(custom-enabled-themes '(wombat))
  '(package-selected-packages '(magit)))

;; Custom Faces
(custom-set-faces
 '(line-number ((t (:inherit (shadow default) :foreground "yellow"))))
 '(tab-bar ((t (:inherit variable-pitch :background "dimgray" :foreground "white"))))
 '(tab-bar-tab ((t (:inherit tab-bar :background "brightblack" :box (:line-width (1 . 1) :style released-button)))))
 '(tab-bar-tab-inactive ((t (:inherit tab-bar-tab :background "dimgray")))))

;; Custom Key Bindings
(global-set-key (kbd "C-c c") 'comint-clear-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c w") 'delete-trailing-whitespace)

;; Custom Macros
(fset 'doxygen (kmacro-lambda-form [?/ ?* ?* ?\C-m ?  ?* ?\C-m ?  ?* ?\C-m ?  ?* ?\C-m ?  ?* ?\C-m ?  ?* ?\C-m ?  ?* ?/ ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?  ?@ ?b ?r ?i ?e ?f ?\C-\[ ?O ?B ?\C-\[ ?O ?B ?  ?@ ?p ?a ?r ?a ?m ?\C-\[ ?O ?B ?  ?@ ?p ?a ?r ?a ?m ?\C-\[ ?O ?B ?\C-\[ ?O ?B ?  ?@ ?r ?e ?t ?u ?r ?n ?s ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ?\C-\[ ?O ?A ? ] 0 "%d"))
