# Vivid — Neovim IDE config

Modular [lazy.nvim](https://github.com/folke/lazy.nvim) config for Neovim 0.12+,
themed with **Catppuccin Latte** (light).

## Layout

```text
init.lua
lua/config/        options, keymaps, autocmds, lazy bootstrap
lua/plugins/       one spec file per feature area
```

## Highlights

- **LSP**: Mason + mason-lspconfig, nvim-lspconfig, lazydev, fidget, navic breadcrumbs, SchemaStore for JSON/YAML
- **Completion**: nvim-cmp + LuaSnip + friendly-snippets
- **Navigation**: Telescope (fzf-native), Flash, nvim-tree + oil, Trouble, treesitter text objects/context
- **Editing**: autopairs, Comment, surround, indent-blankline, visual-multi, undotree, conform + Mason formatters
- **Git**: gitsigns, fugitive, lazygit, Octo
- **Debug**: nvim-dap + dap-ui + virtual text (Python/Go ready)
- **UI**: catppuccin latte, lualine, bufferline, noice, notify, which-key, alpha dashboard, zen-mode/twilight, toggleterm, persistence sessions

A Nerd Font is recommended for the icons.

## Commands

| Command | What |
| --- | --- |
| `:Lazy` | Plugin manager |
| `:Mason` | LSP/formatter installer |
| `:TSUpdate` | Update treesitter parsers |
| `:Trouble` | Diagnostics / symbols / references |
| `:ZenMode` | Distraction-free editing |
| `:LazyGit` | Full-screen git client |

## Key mappings

`<leader>` is `Space`.

### Files / search
- `ff` find files · `fg` live grep · `fr` recent files · `fb` buffers
- `fs` search word under cursor · `fz` fuzzy search in buffer · `fd` diagnostics
- `/` search in current buffer · `fo` resume last search
- `e` toggle file tree · `E` reveal current file · `-` oil parent directory

### Code / LSP
- `gd` definition · `gD` declaration · `gr` references · `gi` implementation · `gy` type definition
- `K` hover · `gK` signature help · `ca` code action · `rn` rename
- `[d` / `]d` previous/next diagnostic · `cd` line diagnostics · `xx` diagnostics list
- `cs` document symbols · `ss` / `sS` telescope symbols · `fm` format buffer · `fa` toggle format-on-save · `ch` toggle inlay hints
- `gcc` comment line · `gc` comment selection · `ys` surround · `S` surround visual

### Git
- `gg` lazygit · `gs` git status · `gc` commit · `gp` push · `gl` pull · `gb` blame
- `]h` / `[h` next/prev hunk · `hs` stage hunk · `hr` reset hunk · `hb` blame line

### Debug
- `F5` continue · `F6` pause · `F8` step over · `F10` step into · `F11` step out
- `F9` / `db` toggle breakpoint · `du` toggle debug UI · `dr` REPL

### Buffers / windows / terminal
- `S-h` / `S-l` previous/next buffer · `bb` pick buffer · `bd` delete buffer
- `<C-h/j/k/l>` window navigation · `<M-arrows>` resize windows
- `<C-\>` toggle float terminal · `tf` / `th` / `tv` terminal layouts · `<Esc><Esc>` leave terminal mode
- `u` undo tree · `zz` zen mode · `?` which-key help

### Sessions
- `qs` select session · `ql` load last session · `qd` stop auto-saving
