local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ── Highlight on yank ────────────────────────────────────────────────────────
-- Briefly flashes the yanked region so you can see what was copied
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ── Restore cursor position ──────────────────────────────────────────────────
-- When reopening a file, jump back to where you were last time
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── Remove trailing whitespace on save ──────────────────────────────────────
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- ── Close certain windows with just 'q' ─────────────────────────────────────
-- Handy for help pages, quickfix, plugin pop-ups
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = { "help", "qf", "notify", "lspinfo", "mason", "lazy", "checkhealth" },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- ── Python: 4-space indent (PEP 8) ──────────────────────────────────────────
autocmd("FileType", {
  group = augroup("python_indent", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
