;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))

;;; キーバインド設定
;;; パッケージで導入した拡張機能に対してキー割り当てられる事もあるので、
;;; すべてのEmacs拡張機能が読み込まれた後に実行する

;; C-hをbackspaceにする
;;(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-c ?") 'help-command)

;; キーバインド定義
;;(define-key global-map (kbd "C-z") 'scroll-down-command)
(define-key global-map (kbd "C-c z") 'suspend-frame)
(define-key global-map (kbd "C-c C-SPC") 'kill-ring-save)

;;折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)

;; 他のウィンドウを閉じる
(define-key global-map (kbd "<f12>") 'delete-other-windows)

;; 行頭でC-kを実行した時に1行削除にする
(setq kill-whole-line t)

;; macOS
(when (eq system-type 'darwin)
  (setq ns-command-modifier (quote meta)))

;;; helm
;;(package-install 'helm)
(require 'helm-config)
(helm-mode 1)
;;(helm-migemo-mode 1)

;; C-hで前の文字削除
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;;(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;;(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)


;; キーバインド
(global-set-key (kbd "C-o") 'helm-mini)
(global-set-key (kbd "C-c a") 'helm-do-ag)
(global-set-key (kbd "C-c h") 'helm-mini)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
;;(define-key global-map (kbd "C-x b") 'helm-for-files)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "<help> b") 'helm-descbinds)

;; dumb-jump
(define-key global-map (kbd "M-.") 'dumb-jump-go)
(define-key global-map (kbd "M-,") 'dumb-jump-back)

; js-mode
(setq indent-tabs-mode nil
      js-indent-level 2)

(setq ruby-insert-encoding-magic-comment nil)

; ruby-mode indent
(setq ruby-deep-indent-paren-style nil)
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)


(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

(defun web-mode-hook ()
  "Hooks for Web mode."

  ;; indent
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-html-offset   2)
  (setq web-mode-style-padding 2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2)

  (local-set-key (kbd "C-m") 'newline-and-indent)
  
  ;; auto tag closing
                                        ;0=no auto-closing
                                        ;1=auto-close with </
                                        ;2=auto-close with > and </
  (setq web-mode-tag-auto-close-style 2)
  )
(add-hook 'web-mode-hook 'web-mode-hook)

(setq typescript-indent-level 2)
