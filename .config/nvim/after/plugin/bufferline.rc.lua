local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})

bufferline.setup({
  options = {
    mode = 'tabs',
    numbers = "none",
    separator_style = 'thin',
    indicator = {
      style = "none",
    },
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    color_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
})
