local wk = require('which-key')
local vgit = require('vgit')
local telescope = require('telescope.builtin')
local api = vim.api
require('plugins/goalt').setup()

vim.g.VM_leader = { default = '<space>v', visual = '<space>v', buffer = 'z' }

vim.keymap.set('n', '-', [[:lua require('lir.float').init()<cr>]], { silent = true })

-- splits
vim.keymap.set('n', 'vv', '<C-w>v', { silent = true })
vim.keymap.set('n', 'ss', '<C-w>s', { silent = true })

-- code navigation
vim.keymap.set('n', '<leader>.', ':GoAlt<cr>')
vim.keymap.set('n', '\\', ':noh<return>')

-- close buffer
vim.keymap.set('n', '<M-q>', [[:Bdelete<cr>]], { silent = true })

-- comments
-- vim.keymap.set('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)')
-- vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)')

-- Diagnostics
vim.keymap.set('n', '<M-p>', [[:Lspsaga diagnostic_jump_prev<cr>]], { silent = true })
vim.keymap.set('n', '<M-n>', [[:Lspsaga diagnostic_jump_next<cr>]], { silent = true })

-- Full redraw finxing syntax highlight bugs
-- vim.keymap.set('n', '<c-l>', [[:nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>]], { silent = true })

-- Mimic behavior from D, C
vim.keymap.set('n', 'Y', 'y$')

-- Indent/un-indent
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- Don't replace buffer when pasting on visual
vim.keymap.set('v', 'p', '"_dP')

-- Save on enter
vim.keymap.set('n', '<CR>', function()
    if api.nvim_eval([[&modified]]) ~= 1 or api.nvim_eval([[&buftype]]) ~= '' then
        return nil
    end
    vim.schedule(function() vim.cmd("write") end)
end, { expr = true })

-- Save without formatting
vim.keymap.set('n', '<S-CR>', function()
    if api.nvim_eval([[&modified]]) ~= 1 or api.nvim_eval([[&buftype]]) ~= '' then
        return nil
    end
    vim.schedule(function() vim.cmd("noautocmd write") end)
end, { expr = true })

-- Copy to system clipboard
vim.keymap.set('v', 'Y', '"+y')

-- Fuzzy finding
vim.keymap.set('n', '<C-p>', [[<cmd>FZFFiles<cr>]])

-- Current file's path in command mode
vim.keymap.set('c', '%%', [[expand('%:h').'/']], { expr = true })

-- lspsaga scrolling
-- scroll down hover doc or scroll in definition preview
vim.keymap.set('n', '<C-f>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]], { silent = true, })
-- scroll up hover doc
vim.keymap.set('n', '<C-b>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]], { silent = true })

vim.keymap.set('n', 'K', [[<cmd>Lspsaga hover_doc<cr>]], { silent = true })

wk.add({
    { 'gD', vim.lsp.buf.declaration,             desc = 'Go to declaration' },
    { 'gd', telescope.lsp_definitions,           desc = 'Go to definition' },
    { 'gy', vim.lsp.buf.type_definition,         desc = 'Go to type' },
    { 'gm', telescope.lsp_implementations,       desc = 'Find implementation' },
    { 'gh', [[<cmd>Lspsaga lsp_finder<cr>]],     desc = 'Smart find references/implementation' },
    { 'gr', telescope.lsp_references,            desc = 'Find references' },
    { 'gK', [[<cmd>Lspsaga signature_help<cr>]], desc = 'Show signature' },
    { 'ga', '<Plug>(LiveEasyAlign)',             desc = 'EasyAlign',                           mode = 'x' },
})

wk.add({
    { '<leader> ',  group = "general" },
    { '<leader> s', ':Alpha<cr>',          desc = 'Home Buffer' },
    { '<leader> c', telescope.commands,    desc = 'Search commands' },
    { '<leader> a', telescope.colorscheme, desc = 'Search colorschemes' },
    { '<leader> h', telescope.help_tags,   desc = 'Help' },
})

wk.add({
    { '<leader>f',  group = "files" },
    { '<leader>ff', telescope.find_files,                                                                      desc = 'File Search' },
    { '<leader>fo', telescope.buffers,                                                                         desc = 'Buffer Search' },
    { '<leader>fm', telescope.oldfiles,                                                                        desc = 'Recent Files' },
    { '<leader>f-', function() require('telescope').extensions.file_browser.file_browser({ cwd = '%:h' }) end, desc = 'File Browser' },
    { '<leader>f.', '<c-^>',                                                                                   desc = 'Go to last buffer' },
})

wk.add({
    { '<leader>g',  group = "git" },
    { '<leader>gs', ':Git<cr>',             desc = 'git status' },
    { '<leader>gb', ':Git blame<cr>',       desc = 'git blame' },
    { '<leader>gc', telescope.git_commits,  desc = 'git commits' },
    { '<leader>gk', telescope.git_bcommits, desc = 'git commits (buffer)' },
})

wk.add({
    { '<leader>h',  group = "hunks" },
    { '<leader>ht', vgit.toggle_live_guttter,         desc = 'Toggle live gutter' },
    { '<leader>hs', vgit.buffer_hunk_stage,           desc = 'Stage Hunk' },
    { '<leader>hp', vgit.buffer_hunk_preview,         desc = 'Preview Hunk' },
    { '<leader>hu', vgit.buffer_hunk_reset,           desc = 'Undo Hunk' },
    { '<leader>hR', vgit.buffer_unstage,              desc = 'Reset Buffer' },
    { '<leader>hl', vgit.buffer_blame_preview,        desc = 'Blame line' },
    { '<leader>hb', vgit.toggle_live_blame,           desc = 'Toggle live blame' },
    { '<leader>ha', vgit.toggle_authorship_code_lens, desc = 'Toggle authors' },
})

wk.add({
    { '<leader>l',  group = "language-server" },
    { '<leader>la', ':Lspsaga code_action<cr>',               desc = 'Code Action' },
    { '<leader>l=', vim.lsp.buf.formatting_sync,              desc = 'Format' },
    { '<leader>lr', ':Lspsaga rename<cr>',                    desc = 'Rename' },
    { '<leader>lk', ':Lspsaga hover_doc<cr>',                 desc = 'Doc' },
    { '<leader>ls', telescope.lsp_dynamic_workspace_symbols,  desc = 'Search Symbols' },
    { '<leader>ld', "<cmd>Trouble document_diagnostics<cr>",  desc = 'Diagnostics' },
    { '<leader>lD', "<cmd>Trouble workspace_diagnostics<cr>", desc = 'Workspace Diagnostics' },
    { '<leader>lt', "<cmd>Vista!!<cr>",                       desc = 'Symbol tree' },
})

wk.add({
    { '<leader>b',  group = "buffer" },
    { '<leader>bd', function() require('bufdelete').bufdelete(0, true) end, desc = 'Delete Buffer' },
    { '<leader>bl', ':b#<cr>',                                              desc = 'Last buffer' },
    { '<leader>bn', ':bnext<cr>',                                           desc = 'Next buffer' },
    { '<leader>bp', ':bprevious<cr>',                                       desc = 'Previous buffer' },
    { '<leader>bs', telescope.buffers,                                      desc = 'Search buffers' },
})

wk.add({
    { '<leader>s',  group = "search" },
    { '<leader>sg', '<cmd>Grepper<cr>',                  desc = 'Find in directory (quickfix)' },
    { '<leader>sf', telescope.live_grep,                 desc = 'Find in directory (live)' },
    { '<leader>sl', ':FZFLines<cr>',                     desc = 'Find in open files' },
    { '<leader>sb', telescope.current_buffer_fuzzy_find, desc = 'Find in buffer' },
    { '<leader>sp', require('spectre').open,             desc = 'Search & Replace' },
})

wk.add({
    { '<leader>d',  group = "debug" },
    { '<leader>dt', ':GoDebug --test<cr>',           desc = 'Debug Test' },
    { '<leader>dr', ':GoDebug --restart<cr>',        desc = 'Restart' },
    { '<leader>dq', ':GoDebug --stop<cr>',           desc = 'Quit' },
    { '<leader>dd', ':GoDebug --file<cr>',           desc = 'Display File' },
    { '<leader>dc', require 'dap'.continue,          desc = 'Continue' },
    { '<leader>dn', require 'dap'.step_over,         desc = 'Next' },
    { '<leader>ds', require 'dap'.step_into,         desc = 'Step Into' },
    { '<leader>do', require 'dap'.step_out,          desc = 'Step Out' },
    { '<leader>db', require 'dap'.toggle_breakpoint, desc = 'Toggle Breakpoint' },
})


wk.add({
    { '<leader>t',  group = "testing" },
    { '<leader>tt', ':TestNearest<cr>', desc = 'Run Nearest' },
    { '<leader>tf', ':TestFile<cr>',    desc = 'Run File' },
    { '<leader>ts', ':TestSuite<cr>',   desc = 'Run Suite' },
    { '<leader>tg', ':TestVisit<cr>',   desc = 'Goto last ran test' },
    { '<leader>t.', ':TestLast<cr>',    desc = 'Run Last' },
})

vim.keymap.set('n', ']t', '<Plug>(ultest-next-fail)')
vim.keymap.set('n', '[t', '<Plug>(ultest-prev-fail)')
