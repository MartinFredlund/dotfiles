-- Leader key must be set before plugins load
-- Space does nothing useful in normal mode by default, so we repurpose it
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
