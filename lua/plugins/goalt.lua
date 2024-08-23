local M = {}

function M.alternative_filename(file)
  if string.match(file, "_test.go$") ~= nil then
    return file:gsub("_test.go$", ".go")
  else
    return file:gsub(".go$", "_test.go")
  end
end

function M.go_to_alt_file()
  if vim.bo.filetype ~= "go" then
    return
  end

  currentFile = vim.api.nvim_buf_get_name(0)
  alternativeFile = M.alternative_filename(currentFile)
  vim.cmd('e ' .. alternativeFile)
end

function M.setup()
  vim.api.nvim_create_user_command('GoAlt', function(opts)
    M.go_to_alt_file()
  end, {})
end

return M
