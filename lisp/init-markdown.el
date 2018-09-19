;; init-markdown.el --- Initialize markdown configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2018 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;; Markdown configurations.
;;

;;; Code:

(use-package markdown-mode
  :ensure-system-package
  (markdown
   (grip . "pip install grip")
   (mdl . "sudo gem install mdl"))
  :defines flycheck-markdown-markdownlint-cli-config
  :preface
  ;; Render and preview via `grip'
  (eval-and-compile
    (defun markdown-to-html ()
      (interactive)
      (let ((port "6419"))
        (start-process "grip" "*gfm-to-html*" "grip" (buffer-file-name) port)
        (browse-url (format "http://localhost:%s/%s.%s"
                            port
                            (file-name-base)
                            (file-name-extension
                             (buffer-file-name)))))))
  :bind (:map markdown-mode-command-map
              ("V" .  markdown-to-html))
  :mode (("README\\.md\\'" . gfm-mode))
  :config
  (when (executable-find "multimarkdown")
    (setq markdown-command "multimarkdown"))

  (with-eval-after-load 'flycheck
    (eval-and-compile
      (defun set-markdownlint-config ()
        "Set the `mardkownlint' config file for the current buffer."
        (when-let* ((md-lint ".markdownlint.json")
                    (md-file buffer-file-name)
                    (md-lint-dir (locate-dominating-file md-file md-lint)))
          (setq-local flycheck-markdown-markdownlint-cli-config (concat md-lint-dir md-lint))))
      (add-hook 'markdown-mode-hook #'set-markdownlint-config)))

  ;; Preview
  (setq markdown-css-paths '("http://thomasf.github.io/solarized-css/solarized-light.min.css")))

(provide 'init-markdown)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-markdown.el ends here
