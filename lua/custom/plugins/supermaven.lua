return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup({
      keymaps = {
        accept_suggestion = '<C-g>', -- kept for fallback, but we disable built-ins
        clear_suggestion = '<C-x>',
        accept_word = '<C-;>',
      },
      -- ignore_filetypes = { cpp = true }, -- or { "cpp", }
      color = {
        suggestion_color = '#5A5A5A',
        cterm = 244,
      },
      log_level = 'info', -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = true, -- we manage keymaps in custom.ai
      condition = function()
        return false
      end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    })
  end,
}
