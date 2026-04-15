return {
  -- ── Mason: LSP server installer ─────────────────────────────────────────
  -- Installs language servers into ~/.local/share/nvim/mason
  -- Open with :Mason to browse and manually install
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- ── Mason-lspconfig: bridge between Mason and vim.lsp ───────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Auto-install these servers on first launch
      ensure_installed = {
        "pyright",   -- Python type checking
        "ruff",      -- Python linting
        "ts_ls",     -- TypeScript / JavaScript
        "eslint",    -- JS/TS linting
        "lua_ls",    -- Lua (for editing this Neovim config)
        "yamlls",    -- YAML (docker-compose, GitHub Actions)
        "jsonls",    -- JSON
        "dockerls",  -- Dockerfile
        "html",      -- HTML
        "cssls",     -- CSS
      },
      -- Automatically call vim.lsp.enable() for every installed server
      automatic_enable = true,
    },
  },

  -- ── nvim-lspconfig: server definitions + new vim.lsp.config API ─────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- ── Global config applied to every server ──────────────────────────
      -- cmp_nvim_lsp tells servers which completion features Neovim supports
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- ── Per-server config ──────────────────────────────────────────────
      -- Only servers that need custom settings are listed here.
      -- The rest are enabled automatically by mason-lspconfig with defaults.

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths  = true,
            },
          },
        },
      })

      vim.lsp.config("eslint", {
        -- Auto-fix all fixable ESLint issues on save
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer  = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      vim.lsp.config("lua_ls", {
        -- Teach lua_ls about Neovim's vim.* globals so it stops complaining
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              library          = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty  = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- ── Keymaps (set when any LSP server attaches to a buffer) ─────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition,      "Go to definition")
          map("gD", vim.lsp.buf.declaration,     "Go to declaration")
          map("gi", vim.lsp.buf.implementation,  "Go to implementation")
          map("gr", vim.lsp.buf.references,      "References")
          map("gt", vim.lsp.buf.type_definition, "Go to type definition")

          -- Documentation
          map("K", vim.lsp.buf.hover, "Hover docs")

          -- Refactoring
          map("<leader>lr", vim.lsp.buf.rename,      "Rename symbol")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")

          -- Diagnostics
          map("[d",         vim.diagnostic.goto_prev,  "Prev diagnostic")
          map("]d",         vim.diagnostic.goto_next,  "Next diagnostic")
          map("<leader>ld", vim.diagnostic.open_float, "Show diagnostic detail")
        end,
      })

      -- ── Diagnostic display ─────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text     = { prefix = "●" },
        signs            = true,
        underline        = true,
        update_in_insert = false, -- don't show errors mid-typing, only on pause
        severity_sort    = true,
      })
    end,
  },

  -- ── Formatting ──────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "<leader>lf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "LSP: Format file",
      },
    },
    opts = {
      formatters_by_ft = {
        python          = { "ruff_format" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        javascript      = { "prettier" },
        json            = { "prettier" },
        yaml            = { "prettier" },
        html            = { "prettier" },
        css             = { "prettier" },
        lua             = { "stylua" },
        markdown        = { "prettier" },
      },
      format_on_save = {
        timeout_ms   = 1000,
        lsp_fallback = true,
      },
    },
  },
}
