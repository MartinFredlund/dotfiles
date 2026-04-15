return {
  -- ── Fuzzy finder ────────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native fzf sorter — much faster than the Lua implementation
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
          -- Show hidden files in all pickers
          file_ignore_patterns = { "node_modules", ".git/", "__pycache__", ".venv" },
        },
      })

      telescope.load_extension("fzf")

      -- Keymaps
      local builtin = require("telescope.builtin")
      local map     = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files,                { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep,                 { desc = "Live grep" })
      map("n", "<leader>fb", builtin.buffers,                   { desc = "Find buffers" })
      map("n", "<leader>fh", builtin.help_tags,                 { desc = "Help tags" })
      map("n", "<leader>fr", builtin.oldfiles,                  { desc = "Recent files" })
      map("n", "<leader>fs", builtin.lsp_document_symbols,      { desc = "Document symbols" })
      map("n", "<leader>fS", builtin.lsp_workspace_symbols,     { desc = "Workspace symbols" })
      map("n", "<leader>fd", builtin.diagnostics,               { desc = "Diagnostics" })
      map("n", "<leader>/",  builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })
    end,
  },

  -- ── Syntax highlighting (Treesitter) ────────────────────────────────────
  -- Treesitter parses code into a syntax tree — far better than regex highlighting
  -- Pinned to v0.9.3 (commit): latest main requires Neovim 0.12+, we're on 0.11
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "13be7a022997446bf96892bf1ac95784681a02e1",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "python", "typescript", "tsx", "javascript",
          "json", "yaml", "dockerfile", "html", "css",
          "markdown", "markdown_inline", "bash", "toml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent    = { enable = true },
        -- Text objects: select a function with `vaf`, a class with `vac`, etc.
        textobjects = {
          select = {
            enable    = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer", -- select entire function
              ["if"] = "@function.inner", -- select function body only
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          -- Jump between functions/classes with ]f [f ]c [c
          move = {
            enable    = true,
            set_jumps = true,
            goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          },
        },
      })

      -- Show current scope (function/class) pinned at top of screen
      require("treesitter-context").setup({ enable = true, max_lines = 3 })
    end,
  },

  -- ── Keybinding hints ────────────────────────────────────────────────────
  -- After pressing leader, wait 300ms and a menu appears showing all options
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- Group labels shown in the which-key popup
      spec = {
        { "<leader>f",  group = "Find" },
        { "<leader>g",  group = "Git" },
        { "<leader>l",  group = "LSP" },
        { "<leader>b",  group = "Buffer" },
        { "<leader>x",  group = "Diagnostics" },
        { "<leader>t",  group = "Terminal" },
      },
    },
  },

  -- ── Git signs in the gutter ─────────────────────────────────────────────
  -- Shows +/~/- next to lines that were added/changed/deleted vs HEAD
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigate between hunks (changed sections)
        map("n", "]g", gs.next_hunk, "Next git hunk")
        map("n", "[g", gs.prev_hunk, "Prev git hunk")

        -- Stage, reset, preview
        map("n", "<leader>gs", gs.stage_hunk,   "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk,   "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  -- ── Lazygit ─────────────────────────────────────────────────────────────
  -- Full Git UI in a floating terminal window
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open Lazygit" },
    },
  },

  -- ── Terminal ────────────────────────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal (horizontal)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",      desc = "Toggle terminal (float)" },
    },
    opts = {
      size = 15,
      shade_terminals = false,
      float_opts = { border = "curved" },
    },
  },

  -- ── Auto pairs ──────────────────────────────────────────────────────────
  -- Automatically closes (, [, {, ", ' as you type
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- ── Surround ────────────────────────────────────────────────────────────
  -- Add/change/delete surrounding characters
  -- ys<motion><char>  add:    ysiw"  wraps current word in quotes
  -- cs<old><new>      change: cs"'   changes " to '
  -- ds<char>          delete: ds"    removes surrounding "
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- ── Flash (jump anywhere) ────────────────────────────────────────────────
  -- Press s then type 2 chars to jump to any visible occurrence
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash jump" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash treesitter select" },
    },
  },
}
