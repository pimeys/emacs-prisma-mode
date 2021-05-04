# emacs-prisma-mode

A quick and dirty emacs major mode for Prisma schemas.

P.S. I have quite limited time for this, so I'd be happy for good pull requests if needing features!

## Yes :)

- Syntax hilighting
- Autoindent
- LSP

## Installation

I'm using [doom-emacs](https://github.com/hlissner/doom-emacs), so to have the mode available I clone the repo to `~/.doom.d/emacs-prisma-mode`, then in `~/.doom.d/config.el` I can set:

```elisp
(load! "emacs-prisma-mode/prisma-mode")
```

Or, you can also install as package at `~/.doom.d/packages.el`

```elisp
(package! prisma-mode :recipe (:host github :repo "pimeys/emacs-prisma-mode" :branch "main"))
```
Note: This package requires [lsp-mode](https://github.com/emacs-lsp/lsp-mode)

```elisp
(package! lsp-mode)
```
## Screenshot

![All its glory](https://raw.githubusercontent.com/pimeys/emacs-prisma-mode/main/emacs-major-mode.png)
