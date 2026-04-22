-- helpers to enable/disable AI tab-completion
local M = {}

local keymap_defs = {
  accept = '<C-g>',
  accept_word = '<C-;>',
  clear = '<C-x>',
}

local function ensure_supermaven_api()
  local ok, lazy = pcall(require, 'lazy')
  if ok then
    pcall(lazy.load, { plugins = { 'supermaven-nvim' } })
  end
  local ok_api, api = pcall(require, 'supermaven-nvim.api')
  if not ok_api then
    vim.notify('Supermaven not available', vim.log.levels.WARN)
    return nil
  end
  return api
end

local function ensure_codeium_loaded()
  if vim.fn.exists(':CodeiumEnable') == 2 then
    return true
  end
  local ok, lazy = pcall(require, 'lazy')
  if ok then
    pcall(lazy.load, { plugins = { 'windsurf.vim' } })
  end
  return vim.fn.exists(':CodeiumEnable') == 2
end

local function codeium_enabled()
  local ok, enabled = pcall(function()
    if vim.fn.exists('*codeium#Enabled') == 1 then
      return vim.fn['codeium#Enabled']() == 1
    end
    if vim.g.codeium_enabled ~= nil then
      return vim.g.codeium_enabled == 1 or vim.g.codeium_enabled == true
    end
    return false
  end)
  return ok and enabled or false
end

local function set_codeium(enable)
  if not ensure_codeium_loaded() then
    if enable then
      vim.notify('Codeium plugin is not available', vim.log.levels.WARN)
    end
    return
  end
  local cmd = enable and 'CodeiumEnable' or 'CodeiumDisable'
  local ok, err = pcall(vim.cmd, cmd)
  if not ok then
    vim.notify('Codeium command failed: ' .. err, vim.log.levels.WARN)
  else
    vim.g.codeium_enabled = enable and 1 or 0
  end
end

local current_provider = nil -- 'supermaven' | 'codeium' | nil
local function detect_provider()
  local api = ensure_supermaven_api()
  if api and api.is_running() then
    return 'supermaven'
  end
  if codeium_enabled() then
    return 'codeium'
  end
  return nil
end

local function map_disabled()
  vim.keymap.set('i', keymap_defs.accept, function()
    vim.notify('AI completion disabled', vim.log.levels.INFO)
  end, { desc = 'AI accept (disabled)' })
  vim.keymap.set('i', keymap_defs.accept_word, function()
    vim.notify('AI completion disabled', vim.log.levels.INFO)
  end, { desc = 'AI accept word (disabled)' })
  vim.keymap.set('i', keymap_defs.clear, function()
    vim.notify('AI completion disabled', vim.log.levels.INFO)
  end, { desc = 'AI clear (disabled)' })
end

local function map_supermaven()
  local ok, preview = pcall(require, 'supermaven-nvim.completion_preview')
  if not ok then
    vim.notify('Supermaven preview not available', vim.log.levels.WARN)
    return
  end
  vim.keymap.set('i', keymap_defs.accept, preview.on_accept_suggestion, { noremap = true, silent = true, desc = 'AI accept (Supermaven)' })
  vim.keymap.set('i', keymap_defs.accept_word, preview.on_accept_suggestion_word, { noremap = true, silent = true, desc = 'AI accept word (Supermaven)' })
  vim.keymap.set('i', keymap_defs.clear, preview.on_dispose_inlay, { noremap = true, silent = true, desc = 'AI clear (Supermaven)' })
end

local function map_codeium()
  if not ensure_codeium_loaded() then
    return
  end
  vim.keymap.set('i', keymap_defs.accept, function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true, desc = 'AI accept (Codeium)' })
  vim.keymap.set('i', keymap_defs.accept_word, function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true, desc = 'AI accept word / next (Codeium)' })
  vim.keymap.set('i', keymap_defs.clear, function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true, desc = 'AI clear (Codeium)' })
end

local function apply_keymaps(provider)
  if provider == 'supermaven' then
    map_supermaven()
  elseif provider == 'codeium' then
    map_codeium()
  else
    map_disabled()
  end
end

function M.enable_supermaven()
  local api = ensure_supermaven_api()
  if not api then
    return
  end
  set_codeium(false)
  if not api.is_running() then
    api.start()
  end
  apply_keymaps('supermaven')
  current_provider = 'supermaven'
  vim.notify('Supermaven enabled (Codeium disabled)', vim.log.levels.INFO)
end

function M.enable_codeium()
  if not ensure_codeium_loaded() then
    return
  end
  local api = ensure_supermaven_api()
  if api then
    api.stop()
  end
  set_codeium(true)
  apply_keymaps('codeium')
  current_provider = 'codeium'
  vim.notify('Codeium enabled (Supermaven disabled)', vim.log.levels.INFO)
end

function M.disable_all()
  local api = ensure_supermaven_api()
  if api then
    api.stop()
  end
  set_codeium(false)
  apply_keymaps(nil)
  current_provider = nil
  vim.notify('AI providers disabled', vim.log.levels.INFO)
end

function M.toggle_supermaven()
  local api = ensure_supermaven_api()
  if not api then
    return
  end
  if current_provider == 'supermaven' and api.is_running() then
    M.disable_all()
  else
    M.enable_supermaven()
  end
end

function M.toggle_codeium()
  if current_provider == 'codeium' then
    M.disable_all()
  else
    M.enable_codeium()
  end
end

function M.setup()
  -- Detect current state to avoid double-start messages, but still default to Supermaven.
  local provider = detect_provider()
  if provider == 'supermaven' then
    set_codeium(false)
    apply_keymaps('supermaven')
    current_provider = 'supermaven'
  elseif provider == 'codeium' then
    local api = ensure_supermaven_api()
    if api then
      api.stop()
    end
    apply_keymaps('codeium')
    current_provider = 'codeium'
  else
    -- default: Supermaven on, Codeium off
    M.enable_supermaven()
  end

  -- user command to turn everything off
  pcall(vim.api.nvim_create_user_command, 'AIOff', function()
    M.disable_all()
  end, { desc = 'Disable all AI providers' })
end

function M.status()
  local provider = current_provider or detect_provider()
  if provider == 'supermaven' then
    return 'AI:SM'
  elseif provider == 'codeium' then
    return 'AI:CI'
  else
    return 'AI:OFF'
  end
end

return M
