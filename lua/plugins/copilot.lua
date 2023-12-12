-- vim.cmd [[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]

vim.keymap.set('i', '<C-a>', 'copilot#Accept("<CR>")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})
vim.g.copilot_no_tab_map = true

vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<M-/>', '<Plug>(copilot-suggest)')
