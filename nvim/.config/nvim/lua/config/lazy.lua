-- Download lazy.nvim automatically on first run
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  -- Don't notify every time a plugin auto-updates in the background
  change_detection = { notify = false },
  -- No plugins need luarocks — disable to silence the health check warning
  rocks = { enabled = false },
  ui = {
    -- Use nerdfont icons in the lazy.nvim UI (requires a Nerd Font terminal)
    icons = {
      cmd  = " ", config = "", event = "", ft = " ",
      init = " ", keys = " ", plugin = " ", runtime = " ",
      source = " ", start = "", task = "✔ ",
    },
  },
})
