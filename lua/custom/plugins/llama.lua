-- Local FIM autocomplete: llama.vim + llama-server (Qwen2.5-Coder 1.5B). Nothing leaves the machine.
local port = 8012

return {
  'ggml-org/llama.vim',
  init = function()
    vim.g.llama_config = {
      endpoint_fim = 'http://127.0.0.1:' .. port .. '/infill',
      show_info = 0,
      -- less context per request: ~2x lower latency, no measured quality loss
      n_suffix = 8,
      ring_n_chunks = 4,
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
  end,
  config = function()
    -- start llama-server in background unless already running (it outlives nvim)
    if vim.fn.executable 'llama-server' == 0 then
      vim.notify('llama-server not found: brew install llama.cpp', vim.log.levels.WARN)
      return
    end
    local health = vim.system({ 'curl', '-sf', 'http://127.0.0.1:' .. port .. '/health' }):wait()
    if health.code ~= 0 then
      vim.system({ 'llama-server', '--fim-qwen-1.5b-default', '--port', tostring(port) }, { detach = true, stdout = false, stderr = false })
    end
  end,
}
