local fzf = require("fzf-lua")

fzf.setup({ "fzf-native" })

vim.keymap.set("n", "<Leader><Leader>", fzf.files)
vim.keymap.set("n", "<Leader>b", fzf.buffers)
vim.keymap.set("n", "<C-T>", fzf.grep)
