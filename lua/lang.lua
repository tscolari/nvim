local lsp_status = require('lsp-status')
local lspkind = require('lspkind')
local trouble = require('trouble')
local lsp_format = require("lsp-format")

lsp_format.setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

trouble.setup {
  use_diagnostic_signs = true,
  signs = {
    -- icons / text used for a diagnostic
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "﫠"
  },
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.server_capabilities.documentRangeFormattingProvider then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  else
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float({
          focus = false,
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        })
      end
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr, -- Make this buffer-local!
      callback = function()
        -- Close only diagnostic floating windows, not all floating windows
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local win_config = vim.api.nvim_win_get_config(win)
          -- Check if it's a diagnostic window before closing
          if win_config.relative ~= "" and vim.fn.win_gettype(win) == "popup" then
            -- You might need to add additional checks here to identify diagnostic windows specifically
            -- For example, check window options or buffer name patterns
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match("diagnostic") or buf_name == "" then
              vim.api.nvim_win_close(win, false)
            end
          end
        end
      end
    })
    vim.opt.updatetime = 5
  end
end

vim.lsp.config('*', {
  root_markers = { '.git/' },
  capabilities = lsp_status.capabilities,
  on_attach = on_attach,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 4,
      format = function(diagnostic)
        -- Only show the first line with virtualtext.
        return string.gsub(diagnostic.message, '\n.*', '')
      end,
    },
    signs = true,
    update_in_insert = false,
  }
)

lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- Lua
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
})
vim.lsp.enable('lua_ls')

-- Rust
vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    }
  }
})
vim.lsp.enable('rust_analyzer')

-- Go
vim.lsp.config('gopls', {
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      semanticTokens = true,
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})
vim.lsp.enable('gopls')

-- Terraform
vim.lsp.config('terraformls', {
  filetypes = { 'terraform', 'tf' },
})
vim.lsp.enable('terraformls')

-- Docker
vim.lsp.config('dockerls', {
  cmd = { 'docker-language-server', 'start', '--stdio' },
})
vim.lsp.enable('dockerls')

-- Yaml
vim.lsp.config('yamlls', {
  capabilities = capabilities,
  settings = {
    yaml = {
      keyOrdering = false,
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
        "docker-compose.yml",
        ["https://json.schemastore.org/chart.json"] = "Chart.yaml"
      }
    }
  }
})
vim.lsp.enable('yamlls')


-- It can't deal with helm templates
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml" },
  callback = function(args)
    -- Disable diagnostics in the buffer
    vim.diagnostic.disable(args.buf)

    -- Disable CursorHold diagnostic popup (like Lspsaga hover diagnostics)
    vim.api.nvim_clear_autocmds({
      event = "CursorHold",
      buffer = args.buf,
    })

    -- Safely clear Lspsaga autocommands if group exists
    local ok, group_autocmds = pcall(vim.api.nvim_get_autocmds, { group = "LspsagaAutocmds" })
    if ok and group_autocmds and #group_autocmds > 0 then
      vim.api.nvim_clear_autocmds({
        group = "LspsagaAutocmds",
        buffer = args.buf,
      })
    end
  end,
})
