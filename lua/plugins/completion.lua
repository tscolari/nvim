local t = require('utils').t
local cmp = require 'cmp'

local next = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif vim.fn["vsnip#available"]() == 1 then
    vim.fn.feedkeys(t("<Plug>(vsnip-expand-or-jump)"), "")
  else
    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
  end
end, { "i", "s" })

local prev = cmp.mapping(function()
  if cmp.visible() then
    cmp.select_prev_item()
  elseif vim.fn["vsnip#jumpable"](-1) == 1 then
    vim.fn.feedkeys(t("<Plug>(vsnip-jump-prev)"), "")
  end
end, { "i", "s" })

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'calc' },
    { name = 'path' },
  },
})
