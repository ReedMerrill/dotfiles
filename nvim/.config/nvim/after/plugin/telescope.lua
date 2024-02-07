local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', builtin.find_files, {}) -- fuzzy find in project
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {}) -- project keyword search
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})   -- search buffers
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {}) -- search help
