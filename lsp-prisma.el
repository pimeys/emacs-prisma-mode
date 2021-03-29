;;; lsp-prisma.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Harshit Pant
;;
;; Author: Harshit Pant <https://github.com/pantharshit00>
;; Maintainer: Harshit Pant <pantharshit00@gmail.com>
;; Created: February 18, 2021
;; Modified: February 18, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/pimeys/emacs-prisma-mode/
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(require 'lsp-mode)

(defgroup lsp-prisma nil
  "LSP support for Prisma using official lsp"
  :group 'lsp-mode
  :link '(url-link "https://github.com/pimeys/emacs-prisma-mode"))

(lsp-dependency 'prisma-language-server
                '(:system "prisma-language-server")
                '(:npm :package "@prisma/language-server"
                  :path "prisma-language-server"))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection  (lambda ()
                     `(,(lsp-package-path 'prisma-language-server)
                       "--stdio"))) 
                  :major-modes '(prisma-mode)
                  :server-id 'prismals
                  :activation-fn (lambda (file-name _mode)
                   (string= (f-ext file-name)
                            "prisma"))
                  :download-server-fn (lambda (_client callback error-callback _update?)
                                        (lsp-package-ensure
                                         'prisma-language-server
                                         callback
                                         error-callback))
                                         ))
(add-to-list 'lsp-language-id-configuration '(prisma-mode . "prisma"))

(provide 'lsp-prisma)
;;; lsp-prisma.el ends here

