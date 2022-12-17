require('zilleplus')


vim.cmd [[set mouse=]]
vim.cmd [[map K <nop>]]
vim.g.mapleader = "K"

local opt = vim.opt
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2

vim.keymap.set('n', '<C-j>', ':cn<CR>', {})
vim.keymap.set('n', '<C-k>', ':cp<CR>', {})

-- max number of autocompletions in popup
opt.pumheight = 15
opt.number = true

vim.keymap.set('n', '<leader>e', vim.diagnostic.goto_prev, {})
