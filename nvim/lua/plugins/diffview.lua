return {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
        require('diffview').setup({
            use_icons = false,         -- Requires nvim-web-devicons
        })
    end,
}

