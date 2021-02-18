;;; prisma-mode.el --- A major mode for editing Prisma data model files. -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2021, by Julius de Bruijn

;; Author: Julius de Bruijn ( bruijn@prisma.io )
;; Version: 0.1
;; Created: 16 Feb 2021
;; Keywords: languages
;; Homepage: https://github.com/prisma/emacs-prisma-mode/

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU General Public License version 2.

;;; Commentary:
;;; Code:

(setq prisma-font-lock-keywords
      (let* (
             ;; We match `model Album {', but hilight only the word `model'.
             ;; Same rules for `enum`, `datasource` and `type'.
             (x-keywords-regexp "^\s*\\(model\\|enum\\|datasource\\|type\\)\s+[a-zA-Z0-9_-]+\s*{")
             ;; Mathces the column name and type, hilighting the type.
             (x-scalar-types-regexp "^\s+[a-zA-Z0-9_-]+\s+\\(Int\\|String\\|Boolean\\|DateTime\\|Float\\|Decimal\\|Json\\)")
             ;; A field attribute, such as `@id' or `@map', comes after the column type.
             (x-field-attributes-regexp "\@\\(id\\|map\\|default\\|relation\\|unique\\|index\\|ignore\\)")
             ;; A block attribute, usually at the end of a block such as model definition.
             ;; Example: `@@id([user_name, email])'
             (x-block-attributes-regexp "\@@\\(id\\|map\\|default\\|relation\\|unique\\|index\\|ignore\\)")
             ;; A native type definition, such as `@db.VarChar(255)'
             (x-native-types-regexp "\@[a-zA-Z0-9_-]+\.[a-zA-Z]+")
             ;; Properties in an attribute, e.g. `fields: [MediaTypeId]'.
             (x-properties-regexp "[a-zA-Z_-]+:")
             ;; An attribute function, given as a parameter between parentheses. E.g. `autoincrement()'
             (x-attribute-functions-regexp "[(]\s*\\(autoincrement\\|cuid\\|uuid\\|now\\|dbgenerated\\)\(\)\s*[)]")
             )
        `(
          ;; order matters
          (,x-block-attributes-regexp . font-lock-preprocessor-face)
          (,x-field-attributes-regexp . font-lock-preprocessor-face)
          (,x-attribute-functions-regexp . (1 font-lock-function-name-face))
          (,x-native-types-regexp . font-lock-preprocessor-face)
          (,x-keywords-regexp . (1 font-lock-keyword-face))
          (,x-properties-regexp . font-lock-variable-name-face)
          (,x-scalar-types-regexp . (1 font-lock-type-face))
          )))

(define-derived-mode prisma-mode js-mode "prisma mode"
  "Major mode for editing Prisma data models."

  (setq-default indent-tabs-mode nil)
  (setq tab-width 2)
  (setq font-lock-defaults '((prisma-font-lock-keywords))))

(add-to-list 'auto-mode-alist '("\\.prisma$" . prisma-mode))

(provide 'prisma-mode)
