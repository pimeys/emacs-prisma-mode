;;; prisma-mode.el --- A major mode for editing Prisma data model files. -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2021, by Julius de Bruijn

;; Author: Julius de Bruijn ( bruijn@prisma.io )
;; Version: 0.1
;; Created: 16 Feb 2021
;; Keywords: languages
;; Homepage: https://github.com/prisma/emacs-prisma-mode/
;; Package-Requires: ((emacs "26.1") (js2-mode "20211201.1250"))

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU
;; General Public License version 2.

;;; Commentary:

;;; Syntax highlight and LSP functionality for the Prisma Schema Language. Using
;;; the LSP functionality requires the npm package @prisma/language-server to
;;; be installed in the system, providing prisma-language-server somewhere in
;;; the path.

;;; Enabling the LSP functionality automatically can be done with a hook:
;;;   (add-hook 'prisma-mode-hook #'lsp-deferred)

;;; Format can happen automatically on save with following hook:
;;;   (add-hook 'before-save-hook #'(lambda () (when (eq major-mode 'prisma-mode)
;;;                                                  (lsp-format-buffer))))

;;; Code:

(when (require 'lsp-mode nil 'noerror)
	(require 'lsp-prisma))

(setq prisma-font-lock-keywords
      (let* (
             ;; We match `model Album {', and highlight `model' as keyword and `Album' as type.
             ;; Same rules for `enum`, `datasource` and `type'.
             (x-keywords-regexp "^\s*\\(model\\|enum\\|datasource\\|generator\\|type\\)\s+\\([a-zA-Z0-9_-]+\\)\s*{")
             ;; Mathces the column name and type, hilighting the type.
             (x-scalar-types-regexp "^\s+[a-zA-Z0-9_-]+\s+\\(Int\\|String\\|Boolean\\|DateTime\\|Float\\|Decimal\\|Json\\|[a-zA-Z0-9_-]+\\)")
             ;; A field attribute, such as `@id' or `@map', comes after the column type.
             (x-field-attributes-regexp "\@\\(id\\|map\\|default\\|relation\\|unique\\|ignore\\)")
             ;; A block attribute, usually at the end of a block such as model definition.
             ;; Example: `@@id([user_name, email])'
             (x-block-attributes-regexp "\@@\\(id\\|map\\|unique\\|index\\|ignore\\|fulltext\\)")
             ;; A native type definition, such as `@db.VarChar(255)'
             (x-native-types-regexp "\@[a-zA-Z0-9_-]+\.[a-zA-Z]+")
             ;; Properties in an attribute, e.g. `fields: [MediaTypeId]'.
             (x-properties-regexp "[a-zA-Z_-]+:")
             ;; Builtin functions. E.g. `autoincrement()'
             (x-attribute-functions-regexp "\\(autoincrement\\|cuid\\|uuid\\|now\\|env\\|dbgenerated\\)\(\.*\)")
             ;; Constants
             (x-constants-regexp "\\(true\\|false\\|null\\)")
             )
        `(
          ;; order matters
          (,x-block-attributes-regexp . font-lock-preprocessor-face)
          (,x-field-attributes-regexp . font-lock-preprocessor-face)
          (,x-attribute-functions-regexp . (1 font-lock-function-name-face))
          (,x-native-types-regexp . font-lock-preprocessor-face)
          (,x-keywords-regexp (1 font-lock-keyword-face) (2 font-lock-type-face))
          (,x-properties-regexp . font-lock-variable-name-face)
          (,x-scalar-types-regexp . (1 font-lock-type-face))
          (,x-constants-regexp . font-lock-constant-face)
          )))

;;;###autoload
(define-derived-mode prisma-mode js-mode "Prisma"
  "Major mode for editing Prisma data models."

  (setq-default indent-tabs-mode nil)
  (setq tab-width 2)
  (setq c-basic-offset 2)
  (setq c-syntactic-indentation nil)
  (setq js-indent-level 2)

  ;; HACK: dont indent after <type>[?!]
  (setq-local js--indent-operator-re "")
  (setq font-lock-defaults '((prisma-font-lock-keywords)))
  (when (eq (bound-and-true-p imenu-create-index-function) 'js--imenu-create-index)
    (setq-local imenu-generic-expression
                '((nil "^\\s-*\\(?:model\\|enum\\)\\s-+\\([[:alnum:]]+\\)\\s-*{" 1)))
    (add-function :before-until (local 'imenu-create-index-function)
                  #'imenu-default-create-index-function)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.prisma$" . prisma-mode))

(provide 'prisma-mode)
;;; prisma-mode.el ends here
