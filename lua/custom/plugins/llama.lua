-- Local FIM autocomplete: llama.vim + llama-server (Qwen2.5-Coder 1.5B on macOS, 7B elsewhere). Nothing leaves the machine.
local port = 8012
local is_mac = vim.fn.has 'macunix' == 1

return {
  'ggml-org/llama.vim',
  init = function()
    local cfg = {
      endpoint_fim = 'http://127.0.0.1:' .. port .. '/infill',
      show_info = 0,
      keymap_fim_accept_full = '<C-g>',
      keymap_fim_accept_line = '',
      keymap_fim_accept_word = '<C-;>',
      -- defaults clash with insert-mode <C-h> (backspace) and normal-mode <Tab>/<Esc>
      keymap_fim_next = '',
      keymap_fim_prev = '',
      keymap_inst_trigger = '',
      keymap_inst_rerun = '',
      keymap_inst_continue = '',
      keymap_inst_accept = '',
      keymap_inst_cancel = '',
    }
    if is_mac then
      -- less context per request on macOS: ~2x lower latency, no measured quality loss
      cfg.n_suffix = 8
      cfg.ring_n_chunks = 4
    end
    vim.g.llama_config = cfg
  end,
  config = function()
    -- start llama-server in background unless already running (it outlives nvim)
    if vim.fn.executable 'llama-server' == 0 then
      local hint = is_mac and 'brew install llama.cpp' or 'paru -S llama.cpp-cuda-git'
      vim.notify('llama-server not found: ' .. hint, vim.log.levels.WARN)
      return
    end
    local health = vim.system({ 'curl', '-sf', 'http://127.0.0.1:' .. port .. '/health' }):wait()
    if health.code ~= 0 then
      local preset = is_mac and '--fim-qwen-1.5b-default' or '--fim-qwen-7b-default'
      vim.system({ 'llama-server', preset, '--port', tostring(port), '--sleep-idle-seconds', '300' }, { detach = true, stdout = false, stderr = false })
    end
  end,
}
