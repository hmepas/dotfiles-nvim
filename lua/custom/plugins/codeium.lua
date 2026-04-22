return {
  'Exafunction/windsurf.vim',
  event = 'BufEnter',
  config = function()
    -- disable codeium bindings (we manage them in custom.ai)
    vim.g.codeium_disable_bindings = 1
    -- start with Codeium disabled by default
    vim.g.codeium_enabled = 0
    pcall(vim.cmd, 'CodeiumDisable')
  end,
}
