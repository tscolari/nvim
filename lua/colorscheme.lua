if not (vim.g.lualine_theme) then
    vim.g.lualine_theme = 'gruvbox-material'
end

if not (vim.g.config_colorscheme) then
    vim.g.config_colorscheme = 'gruvbox-material'
end

vim.cmd([[silent! colorscheme ]] .. vim.g.config_colorscheme)
