return {
 'Wansmer/langmapper.nvim',
 lazy = false,
 priority = 1, -- High priority is needed if you will use `autoremap()`
 config = function()
   require('langmapper').setup {
    hack_keymap = false, -- prevents from showing localized keyman in which-key
   }
 end,
}
