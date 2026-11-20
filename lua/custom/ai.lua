-- AI tab-completion status for the statusline (provider: llama.vim)
local M = {}

function M.status()
  -- llama.vim clears its augroup on :LlamaDisable
  return vim.fn.exists '#llama#BufEnter' == 1 and 'AI:LL' or 'AI:OFF'
end

return M
