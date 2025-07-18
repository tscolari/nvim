require('packer-init')
local packer = require('packer')
local has_module = require('utils').has_module

vim.cmd([[
augroup config#update
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]])

packer.startup {
    function(use)
        if has_module('user.plugins') then
            local user_plugins = require('user.plugins')
            if user_plugins and user_plugins.plugins then
                user_plugins.plugins(use)
            end
        end

        -- Packer can manage itself as an optional plugin
        use 'wbthomason/packer.nvim'

        use {
            'williamboman/mason.nvim',
            -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            config = function()
                require("mason").setup()
                require("mason-lspconfig").setup()
            end
        }

        use 'nvim-lua/plenary.nvim'
        use {
            'rcarriga/nvim-notify',
            config = function() vim.notify = require('notify') end,
        }

        use 'christoomey/vim-tmux-navigator'

        use 'sainnhe/gruvbox-material'
        use 'morhetz/gruvbox'
        use 'rafamadriz/neon'
        use 'navarasu/onedark.nvim'

        use 'nvim-tree/nvim-web-devicons'
        use {
            'hoob3rt/lualine.nvim',
            config = function() require('plugins.lualine') end,
        }

        use 'moll/vim-bbye'

        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                { 'nvim-lua/popup.nvim' },
                { 'nvim-lua/plenary.nvim' },
                { 'nvim-telescope/telescope-fzf-native.nvim',  run = 'make' },
                { 'nvim-telescope/telescope-file-browser.nvim' },
            },
            config = function() require('plugins.telescope') end,
        }

        use {
            'junegunn/fzf.vim',
            requires = { 'junegunn/fzf', run = vim.fn['fzf#install'] },
            setup = function() vim.g.fzf_command_prefix = 'FZF' end,
            config = function() require('plugins.fzf') end,
        }

        use {
            'nvimdev/lspsaga.nvim',
            after = 'nvim-lspconfig',
            config = function()
                require('lspsaga').setup({
                    lightbulb = { enable = false },
                })
            end,
        }

        use {
            'lukas-reineke/lsp-format.nvim',
            'folke/lsp-colors.nvim',
            'folke/trouble.nvim',
            'onsails/lspkind-nvim',
            'ray-x/lsp_signature.nvim',
            'nvim-lua/lsp-status.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
        }

        use {
            'stevearc/conform.nvim',
            config = function()
                local conform = require("conform")

                conform.setup({
                    formatters_by_ft = {
                        go = { "gofmt", "goimports" },
                    },
                    format_on_save = {
                        async = false,
                        timeout_ms = 500,
                        lsp_format = "fallback",
                    },
                })
            end,
        }

        use {
            "zbirenbaum/copilot.lua",
            config = function()
                require('plugins/avante')
            end,
        }

        use {
            "zbirenbaum/copilot-cmp",
            after = { "copilot.lua" },
            config = function()
                require("copilot_cmp").setup()
            end
        }

        use {
            "hrsh7th/nvim-cmp",
            requires = {
                "hrsh7th/vim-vsnip",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-vsnip",
                "hrsh7th/cmp-calc",
                "zbirenbaum/copilot-cmp",
            },
            config = function() require('plugins/completion') end,
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            requires = {
                {
                    'nvim-treesitter/nvim-treesitter-textobjects',
                },
            },
            config = function() require('plugins.treesitter') end,
        }

        use {
            'HiPhish/rainbow-delimiters.nvim',
            'windwp/nvim-ts-autotag',
            'JoosepAlviste/nvim-ts-context-commentstring'
        }
        use {
            'windwp/nvim-autopairs',
            config = function() require('plugins.autopairs') end,
        }

        use {
            'RRethy/nvim-treesitter-endwise',
            config = function()
                require('nvim-treesitter.configs').setup {
                    endwise = {
                        enable = true,
                    },
                }
            end
        }

        use {
            'folke/which-key.nvim',
            config = function() require('which-key').setup {} end
        }

        use {
            'jghauser/mkdir.nvim',
            config = function() require('mkdir') end,
        }

        use {
            'tanvirtin/vgit.nvim',
            requires = {
                'nvim-lua/plenary.nvim'
            },
            config = function() require('plugins.vgit') end,
        }

        use {
            'ray-x/guihua.lua'
        }

        use {
            'goolord/alpha-nvim',
            config = function() require('plugins.dashboard') end,
        }

        use {
            'hrsh7th/vim-vsnip',
            requires = {
                'hrsh7th/vim-vsnip-integ',
                'rafamadriz/friendly-snippets',
            },
        }

        use {
            'lukas-reineke/indent-blankline.nvim',
            config = function()
                vim.g.indent_blankline_char = '▏'

                vim.g.indent_blankline_filetype_exclude = { 'help', 'terminal', 'dashboard', 'nofile' }
                vim.g.indent_blankline_buftype_exclude = { 'terminal' }

                vim.g.indent_blankline_show_trailing_blankline_indent = false
                vim.g.indent_blankline_show_first_indent_level = false
            end,
        }
        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }

        use 'kevinhwang91/nvim-bqf'

        -- file explorer
        use {
            'tamago324/lir.nvim',
            requires = { 'tamago324/lir-git-status.nvim' },
            config = function() require('plugins.lir') end,
        }

        use 'windwp/nvim-spectre'
        use {
            'karb94/neoscroll.nvim',
            config = function() require('neoscroll').setup() end,
        }
        use 'sindrets/diffview.nvim'
        use {
            'nvim-neotest/neotest',
            requires = {
                'haydenmeade/neotest-jest',
                'mfussenegger/nvim-dap',
                'nvim-neotest/neotest-go',
                'nvim-neotest/neotest-vim-test',
                'nvim-neotest/nvim-nio',
                'nvim-telescope/telescope-dap.nvim',
                'rcarriga/nvim-dap-ui',
                'theHamsta/nvim-dap-virtual-text',
                'vim-test/vim-test',
            },
            config = function() require('plugins/test') end,
        }

        -- generic (non lua) plugins
        use 'AndrewRadev/splitjoin.vim'
        use 'bronson/vim-trailing-whitespace'
        use 'junegunn/vim-easy-align'
        use 'kopischke/vim-fetch'
        use 'liuchengxu/vista.vim'
        use 'machakann/vim-swap'
        use 'matze/vim-move'
        use 'mbbill/undotree'
        use 'mg979/vim-visual-multi'
        use 'romainl/vim-qf'
        use 'tommcdo/vim-exchange'
        use 'preservim/vimux'
        use 'skywind3000/asyncrun.vim'
        use 'sk1418/Join'

        use {
            'mhinz/vim-grepper',
            config = function()
                vim.g.grepper = {
                    tools = { 'rg', 'git' },
                    simple_prompt = 0,
                    prompt_mapping_tool = '<F10>',
                    prompt_mapping_dir = '<F11>',
                    prompt_mapping_side = '<F12>',
                }
            end,
        }

        -- thanks tpope
        use 'tpope/vim-abolish'
        use 'tpope/vim-eunuch'
        use 'tpope/vim-fugitive'
        use 'tpope/vim-repeat'
        use 'tpope/vim-rhubarb'
        use 'tpope/vim-sleuth'
        use 'tpope/vim-surround'
        use 'tpope/vim-unimpaired'

        use 'tscolari/goalt.nvim'

        -- languages
        use {
            'tpope/vim-markdown',
            ft = 'markdown',
        }
        use 'PotatoesMaster/i3-vim-syntax'
    end,
}

packer.install()
vim.cmd('source ' .. vim.fn.stdpath('data') .. '/plugin/packer_compiled.lua')
return packer
