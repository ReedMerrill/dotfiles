return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = { {'nvim-lua/plenary.nvim'} },
    opts = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
    },
}
