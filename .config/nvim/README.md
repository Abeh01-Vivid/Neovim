# Vivid

A modular, IDE-style Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim),
themed with **Catppuccin Latte** (light) and tuned for Neovim **0.12+**.

<!-- Add a screenshot of the dashboard here:
![Vivid dashboard](assets/dashboard.png)
-->

## Features

- **LSP**: Mason + mason-lspconfig, native `vim.lsp.config` / `vim.lsp.enable`, lazydev, fidget, navic breadcrumbs, SchemaStore for JSON/YAML
- **Completion**: nvim-cmp + LuaSnip + friendly-snippets
- **Navigation**: Telescope (fzf-native), Flash, nvim-tree + oil, Trouble, treesitter text objects and sticky context
- **Editing**: autopairs, Comment, surround, indent-blankline, visual-multi, undotree, conform (format on save, toggleable)
- **Git**: gitsigns, fugitive, lazygit, Octo
- **Debugging**: nvim-dap + dap-ui + virtual text (Python and Go ready)
- **UI**: Catppuccin Latte, lualine, bufferline, noice, notify, which-key, alpha dashboard, zen-mode/twilight, toggleterm, persistence sessions

## Requirements

| Needed for | Packages |
| --- | --- |
| Core | `neovim` 0.12+, `git`, a [Nerd Font](https://www.nerdfonts.com/) in your terminal |
| Search | `ripgrep` |
| Building plugins and parsers | `gcc` (or `clang`), `make`, `tree-sitter-cli` |
| Language servers (via Mason) | `nodejs` + `npm`, `python`, `unzip`, `curl` |
| Optional | `lazygit` (`<leader>gg`), `gh` (Octo) |

### Arch / CachyOS

```fish
sudo pacman -S --needed neovim git ripgrep gcc make tree-sitter-cli nodejs npm python unzip curl lazygit
```

### NixOS

Mason downloads prebuilt binaries that usually don't run on NixOS. Install the language servers and
formatters you need from nixpkgs instead (for example `lua-language-server`, `pyright`, `rust-analyzer`,
`stylua`, `prettier`). This config automatically enables any server in its list that is already on
your `PATH`.

## Install

Back up any existing config first, then clone this repo as your Neovim config:

```fish
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/<your-user>/<your-repo> ~/.config/nvim
nvim
```

On first launch lazy.nvim installs every plugin, treesitter builds its parsers and Mason installs the
language servers. Let it finish, then restart Neovim.

To start from a clean slate later, remove the plugin data (this keeps your config):

```fish
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

## Layout

```text
init.lua              entry point
lazy-lock.json        pinned plugin versions
lua/config/
  options.lua         editor options and diagnostics
  keymaps.lua         general keymaps
  autocmds.lua        autocommands
  lazy.lua            lazy.nvim bootstrap
lua/plugins/          one spec file per feature area
  colorscheme.lua  completion.lua  dap.lua  editor.lua  git.lua
  lsp.lua  telescope.lua  treesitter.lua  ui.lua
```

## Commands

| Command | What it does |
| --- | --- |
| `:Lazy` | Plugin manager |
| `:Mason` | Install LSP servers, formatters and debuggers |
| `:TSUpdate` | Update treesitter parsers |
| `:checkhealth` | Diagnose problems |
| `:Trouble` | Diagnostics, symbols, references |
| `:ZenMode` | Distraction-free editing |
| `:LazyGit` | Full-screen git client |

## Key mappings

`<leader>` is `Space`. Press it and wait to see which-key hints, or `<leader>?` for every mapping.

### General

| Keys | Action |
| --- | --- |
| `<C-h/j/k/l>` | Move between windows |
| `<M-arrows>` | Resize windows |
| `J` / `K` (visual) | Move selection down / up |
| `<C-s>` | Save |
| `U` | Redo |
| `<Esc>` | Clear search highlight |
| `<leader>+` / `<leader>-` | Increment / decrement number |
| `<leader>qq` / `<leader>qQ` | Quit all / force quit all |
| `]q` / `[q` | Next / previous quickfix item |
| `<Esc><Esc>` | Leave terminal mode |

### Files and search

| Keys | Action |
| --- | --- |
| `<leader>ff` / `fg` / `fb` / `fr` | Find files / live grep / buffers / recent files |
| `<leader>fs` / `fz` / `<leader>/` | Word under cursor / fuzzy search in buffer |
| `<leader>fd` / `fh` / `fk` / `fc` | Diagnostics / help tags / keymaps / commands |
| `<leader>fo` / `fp` / `<leader>:` | Resume search / sessions / command history |
| `<leader>ft` | TODO comments |
| `<leader>e` / `<leader>E` | File tree / reveal current file |
| `-` | Open parent directory (oil) |

### Code and LSP

| Keys | Action |
| --- | --- |
| `gd` `gD` `gr` `gi` `gy` | Definition, declaration, references, implementation, type definition |
| `K` / `gK` | Hover / signature help |
| `<leader>ca` / `<leader>rn` | Code action / rename |
| `<leader>cd` / `<leader>cq` | Line diagnostics / diagnostics to location list |
| `<leader>ss` / `<leader>sS` | Document / workspace symbols |
| `<leader>ch` | Toggle inlay hints |
| `<leader>fm` | Format buffer or selection |
| `<leader>fa` | Toggle format on save |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>xx` `xX` `xL` `xQ` | Trouble: diagnostics, buffer diagnostics, loclist, quickfix |
| `<leader>cs` / `<leader>cl` | Trouble: symbols / LSP locations |
| `gcc` / `gc` | Comment line / selection |
| `ys` `yss` `ds` `cs` `S` | Surround |
| `s` / `S` | Flash jump / Flash treesitter |

### Treesitter text objects

| Keys | Action |
| --- | --- |
| `af` `if` `ac` `ic` `aa` `ia` | Select function, class, argument (outer / inner) |
| `]f` `[f` | Next / previous function |
| `]]` `[[` | Next / previous class |
| `]a` `[a` | Next / previous argument |
| `<leader>ta` / `<leader>tA` | Swap argument with next / previous |
| `[C` | Jump to sticky context |
| `]t` / `[t` | Next / previous TODO comment |

### Git

| Keys | Action |
| --- | --- |
| `<leader>gg` / `gf` | LazyGit / LazyGit for current file |
| `<leader>gs` `gc` `gp` `gl` `gb` `gd` | Fugitive: status, commit, push, pull, blame, diff |
| `<leader>gi` / `<leader>gP` | GitHub issues / pull requests (Octo) |
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` `hr` `hS` `hR` | Stage / reset hunk, stage / reset buffer |
| `<leader>hp` `hb` `htb` | Preview hunk, blame line, toggle line blame |
| `<leader>hd` / `hD` | Diff against index / last commit |

### Debugging

| Keys | Action |
| --- | --- |
| `F5` / `F6` | Continue / pause |
| `F8` `F10` `F11` | Step over / into / out |
| `F9` or `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>du` `dr` `dl` `dt` | Toggle UI, REPL, run last, terminate |

### Buffers, terminal and sessions

| Keys | Action |
| --- | --- |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bb` `bd` `bp` `bP` `br` `bl` | Pick, delete, pin, close unpinned, close right, close left |
| `<C-\>` | Toggle floating terminal |
| `<leader>tf` `th` `tv` | Float / horizontal / vertical terminal |
| `<leader>qs` `ql` `qd` | Select session / load last / stop saving |
| `<leader>u` | Undo tree |
| `<leader>zz` | Zen mode |
| `<C-n>` | Multiple cursors (visual-multi) |

## Customizing

- **Theme**: change `flavour` in `lua/plugins/colorscheme.lua` (the config also sets `background` in `options.lua`).
- **Language servers**: edit the `servers` list at the top of `lua/plugins/lsp.lua`.
- **Formatters**: edit `formatters_by_ft` in `lua/plugins/editor.lua`.
- **Dashboard**: the Vivid header and buttons live in the alpha spec in `lua/plugins/ui.lua`.

## Troubleshooting

- **Icons look broken**: set a Nerd Font in your terminal.
- **Treesitter parsers fail to build**: install `gcc` and `tree-sitter-cli`, then run `:TSUpdate`.
- **A plugin fails to clone**: check the repo name in its spec, then run `:Lazy sync`.
- **Language server doesn't start**: run `:checkhealth vim.lsp` and `:Mason`. On NixOS, install it from nixpkgs.
