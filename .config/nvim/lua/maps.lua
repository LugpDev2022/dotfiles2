local keymap = vim.keymap
vim.g.mapleader = ' '

-- Do not yank with x
keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Save/quit
keymap.set('n', '<Leader>w', ':w<CR>')
keymap.set('n', '<Leader>q', ':q<CR>')

-- Select all
keymap.set('n', '<Leader>a', 'gg<S-v>G')

-- Tabs
keymap.set('n', '<Leader>t', ':tabedit<Return>', { silent = true })
keymap.set('n', '<tab>', ':tabNext<Return>', { silent = true })
keymap.set('n', '<S-tab>', ':tabprevious<Return>', { silent = true })

--Split window
keymap.set('n', '<Leader>s', ':vsplit<Return><C-w>w', { silent = true })
keymap.set('n', '<Leader>z', ':split<Return><C-w>w', { silent = true })

-- Move between windows
keymap.set('', '<Leader>h', '<C-w>h')
keymap.set('', '<Leader>k', '<C-w>k')
keymap.set('', '<Leader>j', '<C-w>j')
keymap.set('', '<Leader>l', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w>h', '<C-w>>')
keymap.set('n', '<C-w>l', '<C-w><')
keymap.set('n', '<C-w>k', '<C-w>+')
keymap.set('n', '<C-w>j', '<C-w>-')