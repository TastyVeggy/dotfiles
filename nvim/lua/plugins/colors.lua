return {
    {
        'folke/tokyonight.nvim',
        name = 'tokyonight',
        lazy = false,
        config = function()
            require('tokyonight').setup({
                style = 'night',
                on_colors = function(colors)
                    colors.bg = "#222236"
                end,
            })
            vim.cmd('colorscheme tokyonight')
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

            vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
            vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })

            vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
            vim.api.nvim_set_hl(0, "VertiSplit", { bg = "none" })
        end,
    },
}
