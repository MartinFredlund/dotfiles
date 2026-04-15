return {
  -- ── Colourscheme ────────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before everything else so colours apply first
    opts = {
      flavour = "mocha", -- darkest variant, easiest on the eyes
      integrations = {
        cmp = true, gitsigns = true, neotree = true,
        telescope = { enabled = true },
        treesitter = true, which_key = true,
        mason = true, lsp_trouble = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Statusline ──────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto", -- auto-detects the active colorscheme
        component_separators = "|",
        section_separators = { left = "", right = "" },
        globalstatus = true, -- single statusline across all splits
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- show relative path
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Buffer tabs ─────────────────────────────────────────────────────────
  -- Shows open buffers as tabs at the top of the screen
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",           -- show LSP error count on buffer tab
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
      },
    },
  },

  -- ── Indent guides ───────────────────────────────────────────────────────
  -- Draws vertical lines to show indentation levels
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- ── File explorer (sidebar) ─────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<cr>",  desc = "Focus file explorer" },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,      -- show hidden files but dim them
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true }, -- auto-reveal current file
      },
    },
  },

  -- ── Todo comments ───────────────────────────────────────────────────────
  -- Highlights TODO, FIXME, HACK, NOTE etc. in code
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    },
  },

  -- ── Diagnostics panel ───────────────────────────────────────────────────
  -- A nicer list view for LSP errors/warnings across the project
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (project)" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions" },
    },
  },
}
