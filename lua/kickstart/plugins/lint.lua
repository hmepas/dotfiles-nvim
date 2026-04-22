return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        python = { 'ruff' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        dockerfile = { "hadolint" },
        json = { "jsonlint" },
      }
      lint.linters.eslint_d.args = {
        '--format',
        'json',
        '--stdin',
        '--stdin-filename',
        function() return vim.api.nvim_buf_get_name(0) end,
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil
      local function has_eslint_config(from_path_upward)
          local eslint_config_files = {
              '.eslintrc',
              '.eslintrc.js',
              '.eslintrc.cjs',
              '.eslintrc.json',
              '.eslintrc.yml',
              '.eslintrc.yaml',
              'eslint.config.js',
              'eslint.config.cjs',
              'eslint.config.mjs',
              'eslint.config.ts',
              'eslint.config.mts',
          }

          return vim.fs.find(eslint_config_files, { upward = true, path = from_path_upward })[1] ~= nil
      end
      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if not vim.bo.modifiable then
            return
          end

          -- Skip eslint_d entirely if there is no eslint config near the file
          local ft = vim.bo.filetype

          local buffer_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
          if (ft == 'javascript' or ft == 'typescript') and not has_eslint_config(buffer_path) then
            return
          end

          lint.try_lint()
        end,
      })
    end,
  },
}
