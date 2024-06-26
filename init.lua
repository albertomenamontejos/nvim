-- TODO Re-size vsplit

--vim.cmd("colorscheme github_dark_high_contrast")
-- "Theme"
--
vim.cmd([[
  match ExtraWhitespace /\s\+$/
  highlight ExtraWhitespace ctermbg=1
  highlight Whitespace ctermfg=236
  highlight Pmenu ctermbg=235 ctermfg=15
  highlight Pmenusel ctermbg=240 ctermfg=15
  highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=7
  highlight StatusLine cterm=NONE ctermfg=yellow ctermbg=darkblue
  highlight StatusLineNC cterm=NONE ctermfg=yellow ctermbg=darkblue
]])

-- The following should survive changing the colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Cosmetic changes",
	callback = function()
		vim.cmd([[
		  highlight VertSplit cterm=NONE ctermbg=NONE
      highlight ExtraWhitespace ctermbg=1
    ]])
	end,
})
-- Most of the options are set by a global $HOME/.editorconfig.
vim.opt.wrap = false
vim.opt.showmatch = true
vim.opt.list = true

-- Keybindings
vim.keymap.set("n", "<C-N>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<C-P>", "<cmd>bprev<cr>")
vim.keymap.set("n", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.g.mapleader = " "
--vim.cmd('colorscheme github_dark_high_contrast')
