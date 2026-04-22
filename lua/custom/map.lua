--- @param opts table Arguments to |nvim_cmd()|
local function cmd(opts)
  local ok, err = pcall(vim.api.nvim_cmd, opts, {})
  if not ok then
    vim.api.nvim_echo({ { err:sub(#'Vim:' + 1) } }, true, { err = true })
  end
end

vim.keymap.set('n', '<C-Enter>', 'o<Esc>', { desc = 'Add new line' })
vim.keymap.set('i', '<C-Enter>', '<Esc>o', { desc = 'Add new line' })


--  buffers navigation
vim.keymap.set('n', '[b', function()
  cmd { cmd = 'bprevious', count = vim.v.count1 }
end, { desc = ':bprevious' })

vim.keymap.set('n', ']b', function()
 cmd { cmd = 'bnext', count = vim.v.count1 }
end, { desc = ':bnext' })

-- mac os x cmd/opt motions compatible with my iterm2 settings
vim.api.nvim_set_keymap('i', '<Find>', '<C-\\><C-O>0', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Select>', '<C-\\><C-O>$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<M-b>', '<C-\\><C-O>b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<M-f>', '<C-\\><C-O>w', { noremap = true, silent = true })

 -- toggle linter, since it's anoying sometimes
vim.keymap.set('n', '<leader>tl', function()
    -- not exactly true, since disabling all diagnostics, but I am ok with that
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '[T]oggle [L]inter' })

local ai = require 'custom.ai'
ai.setup()

-- free up <leader>p (was paste) to avoid clashing with <leader>-pa* toggles
-- vim.keymap.del({'n', 'v'}, '<leader>p') not set 

vim.keymap.set('n', '<leader>paw', ai.toggle_codeium, { desc = '[P]lugins [A]I [W]indsurf toggle' })
vim.keymap.set('n', '<leader>pas', ai.toggle_supermaven, { desc = '[P]lugins [A]I [S]upermaven toggle' })
