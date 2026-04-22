local opt = vim.opt
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

vim.o.selection = 'exclusive'

opt.more = false

opt.foldmethod = 'manual'

opt.listchars = { tab = '» ', trail = '·', lead = '·', nbsp = '␣' }

-- setting that controls how certain syntax elements are displayed, allowing characters like ligatures or symbols to be replaced with a different, often more readable, character. You can set it in your configuration, but be aware that other plugins can override it, which can be checked with :verbose set conceallevel. Common values are 0 (no concealing), 1 (concealing in normal mode), 2 (concealing in normal and visual mode), and 3 (concealing in all modes)
vim.opt.conceallevel = 2

