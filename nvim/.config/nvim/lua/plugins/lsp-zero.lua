return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        -- manage LSPs within nvim
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'L3MON4D3/LuaSnip'},
    },
}
