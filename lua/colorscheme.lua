if not (vim.g.lualine_theme) then
    vim.g.lualine_theme = 'catppuccin-mocha'
end

if not (vim.g.config_colorscheme) then
    vim.g.config_colorscheme = 'catppuccin-mocha'
end

vim.cmd([[silent! colorscheme ]] .. vim.g.config_colorscheme)
