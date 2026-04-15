return {
  -- ── Snippet engine ──────────────────────────────────────────────────────
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = {
      -- A big collection of pre-made snippets for most languages
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- ── Completion engine ───────────────────────────────────────────────────
  -- nvim-cmp shows a popup menu as you type with suggestions from multiple sources
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- suggestions from the language server
      "hrsh7th/cmp-buffer",    -- suggestions from words in the current buffer
      "hrsh7th/cmp-path",      -- file path completion
      "saadparwaiz1/cmp_luasnip", -- snippet completion
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",  -- icons in the completion menu (shows kind: Function, Variable, etc.)
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Completion menu keymaps
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"]   = cmp.mapping.select_prev_item(),   -- move up in menu
          ["<C-j>"]   = cmp.mapping.select_next_item(),   -- move down in menu
          ["<C-b>"]   = cmp.mapping.scroll_docs(-4),      -- scroll docs up
          ["<C-f>"]   = cmp.mapping.scroll_docs(4),       -- scroll docs down
          ["<C-Space>"] = cmp.mapping.complete(),          -- force open menu
          ["<C-e>"]   = cmp.mapping.abort(),              -- close menu
          ["<CR>"]    = cmp.mapping.confirm({ select = false }), -- confirm selection
          -- Tab: confirm snippet expansion, or jump to next snippet placeholder
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Sources ordered by priority
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP suggestions first
          { name = "luasnip"  }, -- then snippets
          { name = "buffer"   }, -- then words in open buffers
          { name = "path"     }, -- then file paths
        }),

        -- Fancy icons showing the type of each suggestion
        formatting = {
          format = lspkind.cmp_format({
            mode   = "symbol_text",
            maxwidth = 50,
          }),
        },

        -- Show a border around the completion and docs windows
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
