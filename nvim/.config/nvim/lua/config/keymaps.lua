local map = vim.keymap.set

-- ── Windows (splits) ────────────────────────────────────────────────────────
-- Navigate between splits with Ctrl + direction (no need to type <C-w>h etc.)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to split below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to split above" })

-- Resize splits with Ctrl + arrow keys
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase split height" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease split height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease split width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase split width" })

-- ── Buffers ─────────────────────────────────────────────────────────────────
-- Shift+h / Shift+l to move between open buffers (like tabs)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- ── Editing QoL ─────────────────────────────────────────────────────────────
-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred when jumping half-pages or searching
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centred)" })
map("n", "n",     "nzzzv",   { desc = "Next search result (centred)" })
map("n", "N",     "Nzzzv",   { desc = "Prev search result (centred)" })

-- Paste over selection without losing what's in your register
-- (by default, p over a selection replaces your clipboard with the deleted text)
map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })

-- Clear search highlight with Escape
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better indenting in visual mode (stays in visual mode after indent)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ── Quickfix list ───────────────────────────────────────────────────────────
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
map("n", "]q", "<cmd>cnext<cr>",     { desc = "Next quickfix item" })

-- ── Misc ────────────────────────────────────────────────────────────────────
-- Save with leader + s (quick muscle memory shortcut)
map({ "n", "i" }, "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Quit all
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
