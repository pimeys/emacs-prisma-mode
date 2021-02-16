# emacs-prisma-mode
A quick and dirty emacs major mode for Prisma schemas

## Yes :)
- Syntax hilighting
- Autoindent

## No :(
- LSP

## Installation

I'm using [doom-emacs](https://github.com/hlissner/doom-emacs), so to have the mode available I clone the repo to `~/.doom.d/emacs-prisma-mode`, then in `~/.doom.d/config.el` I can set:

```elisp
(load "~/.doom.d/emacs-prisma-mode/prisma-mode.el")
(require 'prisma-mode)

(setq auto-mode-alist
      (cons '("\\.prisma$" . prisma-mode) auto-mode-alist))
```

## Screenshot

![All its glory](https://raw.githubusercontent.com/pimeys/emacs-prisma-mode/main/emacs-major-mode.png)
