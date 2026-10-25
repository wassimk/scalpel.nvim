--
-- Minimal config for recording the README demo with VHS (see demo/scalpel.tape)
--

local onedark_dir = os.getenv('ONEDARK_DIR') or '/tmp/onedark.nvim'

if vim.fn.isdirectory(onedark_dir) == 0 then
  vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/navarasu/onedark.nvim',
    onedark_dir,
  })
end

vim.opt.rtp:append(os.getenv('SCALPEL_DIR') or '.')
vim.opt.rtp:append(onedark_dir)

vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.shortmess:append('I')

require('onedark').setup({ style = 'darker' })
require('onedark').load()

require('scalpel').setup()

vim.keymap.set({ 'n', 'x' }, '<leader>e', function()
  require('scalpel').substitute()
end, { desc = 'substitute word(s)' })
