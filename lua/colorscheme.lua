if not (vim.g.lualine_theme) then
    -- vim.g.lualine_theme = 'onedark'
    vim.g.lualine_theme = 'gruvbox'
end

if not (vim.g.config_colorscheme) then
    -- vim.g.config_colorscheme = 'onedark'
    vim.g.config_colorscheme = 'gruvbox'
end

vim.cmd([[silent! colorscheme ]] .. vim.g.config_colorscheme)
