## Native Neovim LSP config

Small Neovim config with:

- no plugins
- no Mason
- no Node
- no Treesitter
- no Telescope
- no `nvim-cmp`

Configured LSPs:

- Python: `pylsp`
- C/C++: `clangd`
- Rust: `rust-analyzer`

The LSPs are enabled by default only when their binary is found in `PATH`.

## Install the config

```sh
mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim/init.lua
```

Requires Neovim 0.11 or newer.

Check:

```sh
nvim --version
```

## Disable LSPs

```sh
NVIM_NO_LSP=1 nvim          # disable all LSPs
NVIM_NO_PY_LSP=1 nvim       # disable Python LSP
NVIM_NO_C_LSP=1 nvim        # disable C/C++ LSP
NVIM_NO_RUST_LSP=1 nvim     # disable Rust LSP
```

## Rust LSP, same on every OS

Use `rustup` for Rust and `rust-analyzer`.

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default stable
rustup component add rust-analyzer rust-src
```

Check:

```sh
rustc --version
cargo --version
rust-analyzer --version
```

## macOS / Homebrew

```sh
brew install neovim python-lsp-server llvm
```

Check:

```sh
nvim --version
pylsp --version
/opt/homebrew/opt/llvm/bin/clangd --version 2>/dev/null || /usr/local/opt/llvm/bin/clangd --version
```

## Debian / Ubuntu

```sh
sudo apt update
sudo apt install neovim python3-pylsp clangd curl build-essential
```

If `clangd` is versioned on your release, install the versioned package instead:

```sh
apt search '^clangd-[0-9]+'
sudo apt install clangd-XX
```

Check:

```sh
nvim --version
pylsp --version
clangd --version || clangd-XX --version
```

## Fedora

```sh
sudo dnf install neovim python3-lsp-server clang-tools-extra curl gcc
```

Check:

```sh
nvim --version
pylsp --version
clangd --version
```

## Arch Linux

```sh
sudo pacman -S neovim python-lsp-server clang curl base-devel
```

Check:

```sh
nvim --version
pylsp --version
clangd --version
```

## Alpine Linux

```sh
sudo apk add neovim py3-lsp-server clang clang-extra-tools curl build-base
```

Check:

```sh
nvim --version
pylsp --version
clangd --version
```

## openSUSE

Verified Python LSP package:

```sh
sudo zypper install neovim python-python-lsp-server curl gcc
```

For C/C++, install the package that provides `clangd` on your openSUSE release:

```sh
zypper search --provides clangd
```

Do not assume a fixed package name without checking.

## FreeBSD

```sh
sudo pkg install neovim py311-python-lsp-server llvm
```

Package names can include Python/LLVM versions. Check first if needed:

```sh
pkg search python-lsp-server
pkg search llvm
```

Check:

```sh
nvim --version
pylsp --version
clangd --version
```

## OpenBSD

```sh
doas pkg_add neovim py3-python-lsp-server clang-tools-extra curl gcc
```

Check:

```sh
nvim --version
pylsp --version
clangd --version
```

## NetBSD / pkgsrc

```sh
sudo pkgin install neovim py313-lsp-server clang
```

Package names can vary by pkgsrc branch. Check first if needed:

```sh
pkgin search lsp-server
pkgin search clang
```

Check:

```sh
nvim --version
pylsp --version
clangd --version
```
## Commands

```vim
:Grep [pattern]       " search text with native vimgrep and open quickfix
:NvimNativeInfo      " show active LSPs and detected binaries
```

Useful Neovim commands, not added by the config:

```vim
:checkhealth vim.lsp
:LspInfo
:Explore
:buffers
:copen
:cclose
```

## Keymaps

Leader is Space.

### General

| Key | Mode | Action |
|---|---|---|
| `<leader>e` | normal | open native file explorer with `:Explore` |
| `<leader>ff` | normal | prompt for a file and open it with native `:find` |
| `<leader>fb` | normal | list buffers, then open `:buffer ` prompt |
| `<leader>fg` | normal | run `:Grep` and search text with native `vimgrep` |
| `<leader>w` | normal | save current file |
| `<leader>q` | normal | quit current window |
| `<leader>h` | normal | clear search highlight |

### Completion

| Key | Mode | Action |
|---|---|---|
| `<C-Space>` | insert | native LSP omnifunc completion, same as `<C-x><C-o>` |
| `<C-@>` | insert | same completion fallback for terminals that send Ctrl-Space as Ctrl-@ |

Native completion keys also still work:

| Key | Mode | Action |
|---|---|---|
| `<C-n>` | insert | next native completion item / word completion |
| `<C-p>` | insert | previous native completion item / word completion |
| `<C-x><C-o>` | insert | LSP omnifunc completion when an LSP is attached |

### Diagnostics

| Key | Mode | Action |
|---|---|---|
| `[d` | normal | previous diagnostic |
| `]d` | normal | next diagnostic |
| `<leader>dl` | normal | show diagnostic for current line |
| `<leader>dq` | normal | put diagnostics in the location list |

### LSP buffer-local keymaps

These exist only after an LSP attaches to the current buffer.

| Key | Mode | Action |
|---|---|---|
| `gd` | normal | go to definition |
| `gD` | normal | go to declaration |
| `gr` | normal | references |
| `gi` | normal | implementation |
| `K` | normal | hover documentation |
| `<leader>rn` | normal | rename symbol |
| `<leader>ca` | normal | code action |
| `<leader>f` | normal | LSP format current buffer |

## Source links

- Neovim install docs: https://neovim.io/doc/install/
- Neovim LSP docs: https://neovim.io/doc/user/lsp/
- Homebrew `python-lsp-server`: https://formulae.brew.sh/formula/python-lsp-server
- Homebrew `llvm`: https://formulae.brew.sh/formula/llvm
- Debian `python3-pylsp`: https://packages.debian.org/python3-pylsp
- Debian `clangd`: https://packages.debian.org/clangd
- Ubuntu Python setup with `python3-pylsp`: https://documentation.ubuntu.com/ubuntu-for-developers/howto/python-setup/
- Ubuntu LLVM/Clang package availability: https://documentation.ubuntu.com/ubuntu-for-developers/reference/availability/llvm/
- Fedora `python3-lsp-server`: https://packages.fedoraproject.org/pkgs/python-lsp-server/python3-lsp-server
- Fedora `clang-tools-extra`: https://packages.fedoraproject.org/pkgs/llvm/clang-tools-extra/
- Arch `python-lsp-server`: https://archlinux.org/packages/extra/any/python-lsp-server/
- Alpine `py3-lsp-server`: https://pkgs.alpinelinux.org/package/edge/community/x86/py3-lsp-server
- Alpine `clang-extra-tools`: https://pkgs.alpinelinux.org/contents?name=clang*-extra-tools&path=usr/bin/clangd
- openSUSE `python-python-lsp-server`: https://software.opensuse.org/package/python-python-lsp-server
- FreeBSD `py-python-lsp-server`: https://www.freshports.org/textproc/py-python-lsp-server/
- FreeBSD LLVM ports: https://www.freshports.org/devel/llvm-devel
- OpenBSD `py-python-lsp-server`: https://openports.pl/path/devel/py-python-lsp-server
- OpenBSD `clang-tools-extra`: https://openports.pl/path/devel/clang-tools-extra
- NetBSD/pkgsrc `py313-lsp-server`: https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/lang/index.html
- rustup components: https://rust-lang.github.io/rustup/concepts/components.html
- rust-analyzer install docs: https://rust-analyzer.github.io/book/installation.html
- asm-lsp upstream: https://github.com/bergercookie/asm-lsp
