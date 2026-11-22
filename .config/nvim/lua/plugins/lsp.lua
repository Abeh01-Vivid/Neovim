-- LSP, Mason, diagnostics enhancements and code intelligence

local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "tailwindcss",
  "ts_ls",
  "vimls",
  "yamlls",
}

local function on_attach(client, bufnr)
  local map = vim.keymap.set
  local function with(desc)
    return { buffer = bufnr, silent = true, desc = desc }
  end

  map("n", "gd", vim.lsp.buf.definition, with("Go to definition"))
  map("n", "gD", vim.lsp.buf.declaration, with("Go to declaration"))
  map("n", "gr", vim.lsp.buf.references, with("Go to references"))
  map("n", "gi", vim.lsp.buf.implementation, with("Go to implementation"))
  map("n", "gy", vim.lsp.buf.type_definition, with("Go to type definition"))
  map("n", "K", vim.lsp.buf.hover, with("Hover documentation"))
  -- <C-k> is window navigation, so signature help lives on gK
  map("n", "gK", vim.lsp.buf.signature_help, with("Signature help"))
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, with("Code action"))
  map("n", "<leader>rn", vim.lsp.buf.rename, with("Rename symbol"))
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, with("Add workspace folder"))
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, with("Remove workspace folder"))
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, with("List workspace folders"))
  -- <leader>e is the file tree and <leader>q* is quit/session, so these moved under <leader>c
  map("n", "<leader>cd", vim.diagnostic.open_float, with("Show line diagnostics"))
  map("n", "<leader>cq", vim.diagnostic.setloclist, with("Diagnostics to location list"))
  map("n", "<leader>ss", function()
    require("telescope.builtin").lsp_document_symbols()
  end, with("Document symbols"))
  map("n", "<leader>sS", function()
    require("telescope.builtin").lsp_workspace_symbols()
  end, with("Workspace symbols"))

  if client.server_capabilities.documentSymbolProvider then
    pcall(function()
      require("nvim-navic").attach(client, bufnr)
    end)
  end

  if client:supports_method("textDocument/inlayHint", bufnr) then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    map("n", "<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, with("Toggle inlay hints"))
  end
end

return {
  -- Mason: install LSP servers, linters and formatters
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll",
      "MasonLog", "MasonUpdate", "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean",
    },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "󰄳 ",
          package_pending = "󰅒 ",
          package_uninstalled = "󰅙 ",
        },
      },
      registries = { "github:mason-org/mason-registry" },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },

  -- Core LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
      "SmiteshP/nvim-navic",
      "folke/lazydev.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      vim.lsp.config("*", { capabilities = capabilities })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            on_attach(client, event.buf)
          end
        end,
      })

      local ok_schemas, schemastore = pcall(require, "schemastore")

      local server_settings = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" }, unusedLocalExclude = { "_*" } },
              -- the Neovim runtime library is provided by lazydev.nvim
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              format = { enable = true },
              hint = { enable = true, arrayIndex = "Disable" },
            },
          },
        },
        ts_ls = {
          init_options = {
            preferences = {
              disableSuggestions = false,
              importModuleSpecifierPreference = "relative",
              includeCompletionsForModuleExports = true,
            },
          },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        clangd = {
          capabilities = vim.tbl_deep_extend("force", capabilities, {
            offsetEncoding = { "utf-16" },
          }),
        },
        jsonls = ok_schemas and {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        } or {},
        yamlls = ok_schemas and {
          settings = {
            yaml = {
              schemas = schemastore.yaml.schemas(),
              schemaStore = { enable = false, url = "" },
              validate = true,
            },
          },
        } or {},
        cssls = {
          settings = {
            css = { validate = true, lint = { unknownAtRules = "ignore" } },
            scss = { validate = true },
            less = { validate = true },
          },
        },
      }

      for name, cfg in pairs(server_settings) do
        vim.lsp.config(name, cfg)
      end

      -- mason-lspconfig v2 installs `ensure_installed` and enables the installed servers itself
      require("mason-lspconfig").setup({ ensure_installed = servers })

      -- Also enable servers that are already on PATH (system packages, Nix, ...), so the
      -- setup keeps working where Mason binaries cannot run.
      for _, name in ipairs(servers) do
        local cmd = (vim.lsp.config[name] or {}).cmd
        if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
          vim.lsp.enable(name)
        end
      end
    end,
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = { winblend = 0, border = "rounded" },
      },
    },
  },

  -- Lua language development (types for the Neovim / lazy APIs)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv", "vim%.loop" } },
        { path = "lazy.nvim", words = { "lazy" } },
      },
    },
  },

  -- Breadcrumbs
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      highlight = true,
      separator = " 󰁔 ",
      depth_limit = 0,
      depth_limit_indicator = "…",
      lazy_update_context = true,
      icons = {
        File = "󰈙 ",
        Module = "󰒓 ",
        Namespace = "󰅦 ",
        Package = "󰒓 ",
        Class = "󰆧 ",
        Method = "󰊕 ",
        Property = "󰆻 ",
        Field = "󰆻 ",
        Constructor = "󰆧 ",
        Enum = "󰕘 ",
        Interface = "󰕘 ",
        Function = "󰊕 ",
        Variable = "󰀫 ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "󰨙 ",
        Array = "󰊕 ",
        Object = "󰆧 ",
        Key = "󰊕 ",
        Null = "󰆧 ",
        EnumMember = "󰕘 ",
        Struct = "󰆧 ",
        Event = "󰊕 ",
        Operator = "󰆕 ",
        TypeParameter = "󰅦 ",
      },
    },
  },

  -- JSON / YAML schemas
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
}
