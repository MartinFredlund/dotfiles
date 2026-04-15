local opt = vim.opt

-- Disable remote providers we don't use (silences health check warnings)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- Line numbers
opt.number = true          -- show absolute line number on current line
opt.relativenumber = true  -- show relative numbers on all other lines (great for jump commands like 5j)

-- Indentation (overridden per filetype by treesitter/LSP)
opt.tabstop = 2            -- a tab character is 2 spaces wide
opt.shiftwidth = 2         -- >> and << indent by 2 spaces
opt.expandtab = true       -- pressing Tab inserts spaces, not a tab character
opt.smartindent = true     -- auto-indent new lines based on context

-- Search
opt.ignorecase = true      -- case-insensitive search by default
opt.smartcase = true       -- ...unless you type an uppercase letter (then case-sensitive)
opt.hlsearch = true        -- highlight all matches
opt.incsearch = true       -- show matches as you type

-- Appearance
opt.termguicolors = true   -- full 24-bit RGB colours (required by most colourschemes)
opt.signcolumn = "yes"     -- always show the gutter (prevents layout shift when diagnostics appear)
opt.cursorline = true      -- highlight the line your cursor is on
opt.scrolloff = 8          -- keep 8 lines visible above/below cursor when scrolling
opt.sidescrolloff = 8
opt.wrap = false           -- don't wrap long lines (horizontal scroll instead)
opt.colorcolumn = "100"    -- vertical guide at 100 chars

-- Splits open in a natural direction
opt.splitright = true      -- vertical splits open to the right
opt.splitbelow = true      -- horizontal splits open below

-- Files
opt.undofile = true        -- persist undo history across sessions (undo even after closing)
opt.swapfile = false       -- no .swp files
opt.backup = false         -- no backup files

-- Performance
opt.updatetime = 250       -- write swap and trigger CursorHold after 250ms idle
opt.timeoutlen = 300       -- ms to wait for a key sequence to complete (affects which-key popup)

-- Completion menu
opt.completeopt = "menu,menuone,noselect"  -- nvim-cmp requirement

-- Clipboard: sync with system clipboard
-- Requires xclip/xsel on Linux or pbcopy on Mac
opt.clipboard = "unnamedplus"

-- Better display of special characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Neovim 0.10+: show substitution preview live in the buffer
opt.inccommand = "split"
